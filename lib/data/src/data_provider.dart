import 'package:flutter/material.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:provider/provider.dart';
import 'dataset.dart';
import 'change_finder.dart';
import 'data_loader.dart';

/// DataProvider read data from dataset user viewer to create list of page
class DataProvider<T extends pb.Object> with ChangeNotifier {
  DataProvider({
    required this.dataset,
    required this.loader,
    this.rowsPerPage,
  });

  /// loader get data from remote
  final DataLoader<T> loader;

  /// dataset keep data
  final Dataset<T> dataset;

  /// _fetchRows keep rows that fetcher load from remote
  List<T>? _fetchRows;

  /// rowsPerPage is number of rows per page for fetch, if null then no fetch allowed
  final int? rowsPerPage;

  /// pageIndex is the page index for fetch
  int pageIndex = 0;

  /// displayRows is rows already in memory and ready to use
  final displayRows = <T>[];

  /// isNotFilledPage return true when available rows can not fill a page and can fetch more
  bool get isNotFilledPage => rowsPerPage != null && displayRows.length < rowsPerPage!;

  /// _moreToFetch is true if there are more data on remote to fetch
  bool _moreToFetch = true;

  /// moreToFetch return true when current page is last page and dataset did not have full data
  bool get isMoreToFetch => dataset.hasMore && rowsPerPage != null && _moreToFetch;

  /// of get DatabaseProvider from context
  static DataProvider<T> of<T extends pb.Object>(BuildContext context) {
    return Provider.of<DataProvider<T>>(context, listen: false);
  }

  /// init data view
  Future<void> init() async {
    await dataset.init();
    await refresh(isInit: true);
  }

  /// dispose database
  @override
  void dispose() {
    _fetchRows = null;
    displayRows.clear();
    dataset.dispose();
    super.dispose();
  }

  /// resetFetch reset fetch to start from beginning
  void resetFetch() {
    _moreToFetch = true;
    pageIndex = 0;
  }

  /// restart clean displayRows start from beginning, you should reload if user change filter/sort
  Future<void> restart({bool notify = true}) async {
    _fetchRows = null;
    await _reload(notify);
  }

  /// refresh load new data data from remote
  Future<void> refresh({
    bool notify = true,
    bool isInit = false,
  }) async {
    final result = await dataset.refresh(
      loader: loader,
      isInit: isInit,
      rowsPerPage: rowsPerPage,
      pageIndex: rowsPerPage != null ? pageIndex : null,
    );

    // fetchRows may need to remove some rows because refresh rows have new one
    if (_fetchRows != null) {
      for (T row in result.refreshRows) {
        _fetchRows!.removeWhere((t) => t.id == row.id);
      }
    }

    // if refreshRows is not enough, fetch rows will have rows to fill
    if (result.fetchRows.isNotEmpty) {
      _saveFetchRow(result.fetchRows);
    }
    await _reload(notify);
  }

  /// _reload will build display rows,
  Future<void> _reload(bool notify) async {
    displayRows.clear();
    displayRows.addAll(dataset.select());
    if (_fetchRows != null) {
      displayRows.addAll(_fetchRows!); // add fetchRows make sure more() work correctly
    }
    notifyListeners();
  }

  /// _saveFetchRow save rows to _fetchRows, return true if there is more rows saved
  bool _saveFetchRow(List<T> fetchRows) {
    if (rowsPerPage == null) {
      return false;
    }
    if (fetchRows.length < rowsPerPage!) {
      _moreToFetch = false;
    }
    if (fetchRows.isNotEmpty) {
      debugPrint('[data_provider] fetch ${fetchRows.length} rows, more=$_moreToFetch');
      pageIndex++;

      if (_fetchRows == null) {
        _fetchRows = fetchRows;
      } else {
        _fetchRows!.addAll(fetchRows);
      }
      displayRows.addAll(fetchRows);
      return true;
    }
    return false;
  }

  /// fetch more data from remote, return true if load more data
  Future<bool> fetch({bool notify = true}) async {
    if (isMoreToFetch) {
      final lastTimestamp = _getFetchTimestamp();
      if (lastTimestamp == null) {
        return false;
      }

      final result = await loader(pb.Sync(
        act: pb.Sync_ACT.ACT_FETCH,
        time: lastTimestamp,
        rows: rowsPerPage!, // only init need to set rowsPerPage
        page: pageIndex, // only init need to set pageIndex
      ));
      if (_saveFetchRow(result.fetchRows)) {
        if (notify) {
          notifyListeners();
        }
        return true;
      }
    }
    return false;
  }

  /// _getFetchTimestamp return timestamp to fetch data
  google.Timestamp? _getFetchTimestamp() {
    if (!isMoreToFetch) {
      return null;
    }
    final rows = displayRows;
    if (rows.isNotEmpty) {
      return rows.last.timestamp;
    }
    return dataset.utcExpiredDate!.timestamp;
  }

  /// _removeFromFetchRows remove row from fetchRows
  void _removeFromFetchRows(T row) {
    if (_fetchRows != null) {
      _fetchRows!.removeWhere((t) => t.id == row.id);
    }
  }

  /// addRow add row to dataset, replace old row if it's already exist
  Future<void> addRow(T row) async {
    await dataset.addRow(row);
    _removeFromFetchRows(row);
    await _reload(true);
  }

  /// removeRow remove row from dataset or fetchRows
  Future<void> removeRow(T row) async {
    await dataset.removeRow(row);
    _removeFromFetchRows(row);
    await _reload(true);
  }
}
