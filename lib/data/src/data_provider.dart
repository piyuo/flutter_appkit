import 'package:flutter/material.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/net/net.dart' as net;
import 'package:provider/provider.dart';
import 'dataset.dart';

/// DataLoader is a function to load data from remote, return refresh rows and fetch rows
typedef DataLoader<T extends net.Object> = Future<(List<T>?, List<T>?)> Function(net.Sync sync);

/// DataProvider read data from dataset user viewer to create list of page
class DataProvider<T extends net.Object> with ChangeNotifier {
  DataProvider({
    required this.loader,
    this.selector,
    this.rowsPerPage,
  });

  /// loader get data from remote
  final DataLoader<T> loader;

  /// selector use in select(), only select data you want display to user (e.g. after filter/sort)
  final DataSelector<T>? selector;

  /// dataset keep data
  late Dataset<T> _dataset;

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
  bool get isMoreToFetch => _dataset.hasMore && rowsPerPage != null && _moreToFetch;

  /// of get DatabaseProvider from context
  static DataProvider<T> of<T extends net.Object>(BuildContext context) {
    return Provider.of<DataProvider<T>>(context, listen: false);
  }

  /// init data view
  Future<void> init({required Dataset<T> dataset}) async {
    _dataset = dataset;
    binDisplay(false);
    //await reload(isInit: true, notify: false);
  }

  /// dispose database
  @override
  void dispose() {
    _fetchRows = null;
    displayRows.clear();
    super.dispose();
  }

  /// select return list of object that match selector or empty if selector is null
  Iterable<T> select() => selector != null ? selector!(_dataset) : _dataset.query();

  /// reload often used in search, it will clear display rows and use new query to refresh/load from remote
  Future<void> reload({
    bool notify = true,
    bool isInit = false,
  }) async {
    _fetchRows = null;
    _moreToFetch = true;
    pageIndex = 0;

    displayRows.clear();
    final selectRows = select();
    // init mode need refresh data and may need fetch to fit rowsPerPage
    bool needFetch = isMoreToFetch && selectRows.length < rowsPerPage!;
    final (newRows, oldRows) = await loader(
      net.Sync(
        refresh: isInit ? _dataset.refreshTimestamp : null,
        fetch: needFetch ? _fetchTimestamp : null,
        rows: needFetch ? rowsPerPage! - selectRows.length : null,
        page: needFetch ? pageIndex : null,
      ),
    );
    if (newRows != null && newRows.isNotEmpty) {
      debugPrint('[data_provider] refresh ${newRows.length} rows');
      await _dataset.insertRows(newRows);
    }
    // oldRows is null mead there may be more data to fetch, if you want no more data use empty list
    if (oldRows != null) {
      _saveOldRows(oldRows, oldRows.length < (rowsPerPage! - selectRows.length));
    }
    binDisplay(notify);
  }

  /// refresh load new data data from remote, return true if load new data
  /// if newRows is not null then use newRows to refresh, in this case loader will not be called
  Future<bool> refresh({
    bool notify = true,
    List<T>? newRows,
  }) async {
    List<T>? readyRows;
    if (newRows == null) {
      final (refreshRows, _) = await loader(
        net.Sync(
          refresh: _dataset.refreshTimestamp,
        ),
      );
      if (refreshRows == null || refreshRows.isEmpty) {
        return false;
      }
      readyRows = refreshRows;
    } else {
      readyRows = newRows;
    }
    debugPrint('[data_provider] refresh ${readyRows.length} rows');
    await _dataset.insertRows(readyRows);
    // fetchRows may need to remove some rows because refresh rows have new one
    for (T row in readyRows) {
      _removeFromFetchRows(row);
    }
    binDisplay(notify);

    // check if delete from refresh make page not full
    if (isMoreToFetch) {
      if (displayRows.length < rowsPerPage!) {
        await fetch(notify: false, customRowsPerPage: rowsPerPage! - displayRows.length);
      }
    }
    return true;
  }

  /// fetch more data from remote, return true if load more data
  Future<bool> fetch({bool notify = true, int? customRowsPerPage}) async {
    final lastTimestamp = _fetchTimestamp;
    if (lastTimestamp == null) {
      return false;
    }
    int rows = customRowsPerPage ?? rowsPerPage!;
    final (_, fetchRows) = await loader(net.Sync(
      fetch: _fetchTimestamp,
      rows: rows,
      page: pageIndex,
    ));
    // fetchRows is null mean there may be more data to fetch, if you want no more data use empty list
    if (fetchRows == null) {
      return false;
    }

    if (_saveOldRows(fetchRows, fetchRows.length < rows)) {
      binDisplay(notify);
      return true;
    }
    return false;
  }

  /// binDisplay load dataset and fetch rows to displayRows
  void binDisplay(bool notify) {
    displayRows.clear();
    displayRows.addAll(select());
    if (_fetchRows != null) {
      displayRows.addAll(_fetchRows!);
    }
    if (notify) {
      notifyListeners();
    }
  }

  /// _saveFetchRows save rows to _fetchRows, return true if there is more rows saved
  bool _saveOldRows(List<T> fetchRows, bool noMore) {
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
    return _dataset.utcExpiredDate!.timestamp;
  }

  /// _removeFromFetchRows remove row from fetchRows
  void _removeFromFetchRows(T row) {
    if (_fetchRows != null) {
      _fetchRows!.removeWhere((t) => t.id == row.id);
    }
  }

  @visibleForTesting
  Future<void> insertRows(List<T> rows) async {
    await _dataset.insertRows(rows);
    binDisplay(true);
  }
}

/*

*/

/*
manual insert row or remove row may break refresh and fetch mechanism
cause refresh/fetch always use row timestamp to increment get new data
so insert row must refresh first to get all new data in order to get correct timestamp
then there is no need to manual insert row, just refresh is enough

/// insertRow insert row to dataset, replace old row if it's already exist
Future<void> insertRow(T row, {bool notify = true}) async {
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
*/