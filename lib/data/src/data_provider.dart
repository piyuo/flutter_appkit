import 'package:flutter/material.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:provider/provider.dart';
import 'dataset.dart';

/// DataLoader is a function to load data from remote, return refresh rows and fetch rows
typedef DataLoader<T extends pb.Object> = Future<(List<T>?, List<T>?)> Function(pb.Sync sync);

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
    await reload(isInit: true, notify: false);
  }

  /// dispose database
  @override
  void dispose() {
    _fetchRows = null;
    displayRows.clear();
    dataset.dispose();
    super.dispose();
  }

  /// reload will build display rows,
  Future<void> reload({
    bool notify = true,
    bool isInit = false,
  }) async {
    _fetchRows = null;
    _moreToFetch = true;
    pageIndex = 0;

    displayRows.clear();
    final selectRows = dataset.select();
    // init mode need refresh data and may need fetch to fit rowsPerPage
    bool needFetch = isMoreToFetch && rowsPerPage != null && selectRows.length < rowsPerPage!;
    final (refreshRows, fetchRows) = await loader(
      pb.Sync(
        refresh: isInit ? dataset.refreshTimestamp : null,
        fetch: needFetch ? _fetchTimestamp : null,
        rows: needFetch ? rowsPerPage! - selectRows.length : null,
        page: needFetch ? pageIndex : null,
      ),
    );
    if (refreshRows != null && refreshRows.isNotEmpty) {
      debugPrint('[data_provider] refresh ${refreshRows.length} rows');
      await dataset.insertRows(refreshRows);
    }
    if (fetchRows != null) {
      _saveFetchRows(fetchRows, fetchRows.length < (rowsPerPage! - selectRows.length));
    }
    _binDisplay(notify);
  }

  /// refresh load new data data from remote, return true if load new data
  Future<bool> refresh({bool notify = true}) async {
    final (refreshRows, _) = await loader(
      pb.Sync(
        refresh: dataset.refreshTimestamp,
      ),
    );
    if (refreshRows == null || refreshRows.isEmpty) {
      return false;
    }
    debugPrint('[data_provider] refresh ${refreshRows.length} rows');
    await dataset.insertRows(refreshRows);
    // fetchRows may need to remove some rows because refresh rows have new one
    for (T row in refreshRows) {
      _removeFromFetchRows(row);
    }
    _binDisplay(notify);
    return true;
  }

  /// fetch more data from remote, return true if load more data
  Future<bool> fetch({bool notify = true}) async {
    final lastTimestamp = _fetchTimestamp;
    if (lastTimestamp == null) {
      return false;
    }

    final (_, fetchRows) = await loader(pb.Sync(
      fetch: _fetchTimestamp,
      rows: rowsPerPage!,
      page: pageIndex,
    ));
    if (fetchRows == null) {
      return false;
    }

    if (_saveFetchRows(fetchRows, fetchRows.length < rowsPerPage!)) {
      _binDisplay(notify);
      return true;
    }
    return false;
  }

  /// addRow add row to dataset, replace old row if it's already exist
  Future<void> addRow(T row, {bool notify = true}) async {
    await dataset.insertRow(row);
    _removeFromFetchRows(row);
    _binDisplay(notify);
  }

  /// removeRow remove row from dataset or fetchRows
  Future<void> removeRow(T row, {bool notify = true}) async {
    await dataset.removeRow(row);
    _removeFromFetchRows(row);
    _binDisplay(notify);
  }

  /// _bindDisplay load dataset and fetch rows to displayRows
  void _binDisplay(bool notify) {
    displayRows.clear();
    displayRows.addAll(dataset.select());
    if (_fetchRows != null) {
      displayRows.addAll(_fetchRows!);
    }
    if (notify) {
      notifyListeners();
    }
  }

  /// _saveFetchRows save rows to _fetchRows, return true if there is more rows saved
  bool _saveFetchRows(List<T> fetchRows, bool noMore) {
    _moreToFetch = !noMore;
    if (fetchRows.isNotEmpty) {
      debugPrint('[data_provider] fetch ${fetchRows.length} rows, more=$_moreToFetch');
      pageIndex++;

      _fetchRows ??= [];
      _fetchRows!.addAll(fetchRows);
      return true;
    }
    return false;
  }

  /// _fetchTimestamp return timestamp to fetch data
  google.Timestamp? get _fetchTimestamp {
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
}
