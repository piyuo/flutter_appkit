import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'types.dart';

class DataSource<T> extends ChangeNotifier {
  DataSource({
    required this.dataLoader,
    this.dataRefresher,
    this.dataComparator,
    this.dataRemover,
    this.diskCacheWriter,
    this.diskCacheReader,
  });

  /// dataLoader call when control need pull data from data source
  final DataLoader<T> dataLoader;

  /// dataRefresher refresh cached rows
  final DataRefresher<T>? dataRefresher;

  /// dataComparator use in compare cached rows to remove duplicate row
  final Comparator<T>? dataComparator;

  /// dataRemover call when control need delete data from data source
  final DataRemover<T>? dataRemover;

  /// diskCacheWriter write to disk cache
  final DiskCacheWriter<T>? diskCacheWriter;

  /// diskCacheReader read from disk cache
  final DiskCacheReader<T>? diskCacheReader;

  /// _rows keep all cached rows
  final List<T> _rows = [];

  /// _selectedRows keep all selected rows
  final List<T> _selectedRows = [];

  /// _rowsPerPage is current rows per page
  int _rowsPerPage = 10;

  /// status is current data source status
  PagedDataSourceStatus status = PagedDataSourceStatus.notLoad;

  /// _busy return true if data source is busy loading data
  bool _busy = false;

  /// _pageIndex is current page index
  int _pageIndex = 0;

  /// currentRows export cached rows for Test
  List<T> get currentRows => _rows;

  /// innerSelectedRows export selected rows for Test
  @visibleForTesting
  List<T> get innerSelectedRows => _selectedRows;

  /// currentPageIndex return current page index
  int get currentPageIndex => _pageIndex;

  /// isBusy return true if data source is busy
  bool get isBusy => _busy;

  /// length return rows length
  int get length => _rows.length;

  /// isEmpty return true if row is empty
  ///
  ///     expect(sds.isEmpty, true);
  ///
  bool get isEmpty => _rows.isEmpty;

  /// isNotEmpty return true if row is not empty
  ///
  ///     expect(sds.isNotEmpty, false);
  ///
  bool get isNotEmpty => _rows.isNotEmpty;

  /// selectedLength return selected rows length
  int get selectedLength => _selectedRows.length;

  /// selectedRowCount return selected row count
  int get selectedRowCount => _selectedRows.length;

  /// loaded return true mean data source already load with data
  bool get loaded => status == PagedDataSourceStatus.load || status == PagedDataSourceStatus.end;

  /// isLastPage return true if current page is last page
  bool get isLastPage => _rows.isEmpty || _pageIndex == pageCount - 1;

  /// pageCount return current total page count
  int get pageCount {
    if (_rows.isEmpty) {
      return 1;
    }
    return (_rows.length / _rowsPerPage).ceil();
  }

  /// _notifyBusy set busy value and notify listener
  void _notifyBusy(bool value) {
    if (value != _busy) {
      _busy = value;
      notifyListeners();
    }
  }

  /// _ensureSelectedRowsExists remove selected rows if it not exists in rows
  void _ensureSelectedRowsExists() {
    for (int i = _selectedRows.length - 1; i >= 0; i--) {
      final selected = _selectedRows[i];
      if (!_rows.contains(selected)) {
        _selectedRows.remove(selected);
      }
    }
  }

  /// saveToCache save data source into disk cache
  ///
  ///     await saveToCache(context);
  ///
  @visibleForTesting
  Future<void> saveToCache(BuildContext context) async {
    if (diskCacheWriter != null && _rows.isNotEmpty) {
      await diskCacheWriter!(
          context,
          CacheInstruction(
            rows: [..._rows],
            status: status,
            rowsPerPage: _rowsPerPage,
          ));
    }
  }

  /// init data source with cache or data loader
  ///
  ///     await init(context);
  ///
  Future<void> init(BuildContext context) async {
    _notifyBusy(true);
    try {
      if (diskCacheReader == null) {
        await loadMoreRow(context);
        return;
      }

      final instruction = await diskCacheReader!(context);
      if (instruction == null) {
        await loadMoreRow(context);
        return;
      }
      _rows.clear();
      _rows.addAll(instruction.rows);
      status = instruction.status;
      _rowsPerPage = instruction.rowsPerPage;
      await refreshNewRow(context);
    } finally {
      _notifyBusy(false);
    }
  }

  /// loadMoreRow load more row after current rows to toPageIndex
  ///
  ///     await loadMoreRow(context,2);
  ///
  Future<void> loadMoreRow(BuildContext context, {int? to}) async {
    _notifyBusy(true);
    try {
      if (status == PagedDataSourceStatus.end) {
        return;
      }

      to = to ?? _pageIndex;
      assert(to >= 0, 'page index can not small than zero');
      var diff = ((to + 1) * _rowsPerPage) - _rows.length;
      if (diff == 0) {
        return;
      }

      final last = _rows.isEmpty ? null : _rows[_rows.length - 1];
      final list = await dataLoader(context, last, diff);
      assert(list.length <= diff, 'data loader load too much data, maxCount is $diff');
      status = list.length < diff ? PagedDataSourceStatus.end : PagedDataSourceStatus.load;
      _rows.addAll(list);
      await saveToCache(context);
      debugPrint('load page $to with ${list.length} row');
    } finally {
      _notifyBusy(false);
    }
  }

  /// deleteRows delete rows that exists in list
  @visibleForTesting
  void deleteRows(List<T> list) {
    for (final item in list) {
      for (int i = _rows.length - 1; i >= 0; i--) {
        if (dataComparator!(item, _rows[i]) == 0) {
          _rows.removeAt(i);
        }
      }
    }
  }

  /// refreshNewRow refresh cached rows
  ///
  ///     await refreshNewRow(context);
  ///
  Future<void> refreshNewRow(BuildContext context) async {
    if (!supportRefresh) {
      return;
    }
    _notifyBusy(true);
    try {
      T? first = _rows.isNotEmpty ? _rows[0] : null;
      final instruction = await dataRefresher!(context, first, _rowsPerPage);
      if (instruction.updated.length == _rowsPerPage) {
        _selectedRows.clear();
        _rows.clear();
        _rows.addAll(instruction.updated);
        status = PagedDataSourceStatus.load;
        _pageIndex = 0;
        await saveToCache(context);
        debugPrint('refresh all');
        return;
      }

      if (instruction.isNotEmpty) {
        deleteRows(instruction.deleted);
        deleteRows(instruction.updated);
        _rows.insertAll(0, instruction.updated);
        if (_pageIndex > pageCount - 1) {
          _pageIndex = pageCount - 1;
        }
        if (status == PagedDataSourceStatus.notLoad) {
          status = PagedDataSourceStatus.load;
        }
        _ensureSelectedRowsExists();
        await saveToCache(context);
        debugPrint('refreshed');
      }
    } finally {
      _notifyBusy(false);
    }
  }

  /// rowCount return current page row count
  ///
  ///     dataSource.rowCount;
  ///
  int get rowCount => getRowCountByPage(_pageIndex);

  /// getRowCountByPage return row total count in current page
  ///
  ///     sds.getRowCountByPage(0);
  ///
  @visibleForTesting
  int getRowCountByPage(int pageIndex) {
    if (pageIndex >= pageCount) {
      return 0; // page not exists
    }
    if (pageIndex == pageCount - 1) {
      return _rows.length - pageIndex * _rowsPerPage;
    }
    return _rowsPerPage;
  }

  /// rowIndex get real row index from current page and position
  ///
  ///     sds.currentPageRow(0,0);
  ///
  int rowIndex(int row) => getRowIndexByPage(_pageIndex, row);

  /// getRowIndexByPage return a row index in page
  ///
  ///     getRowIndexByPage(0,0);
  ///
  @visibleForTesting
  int getRowIndexByPage(int pageIndex, int position) => pageIndex * _rowsPerPage + position;

  /// row return a row by row index
  ///
  ///     sds.row(1);
  ///
  T? row(int rowIndex) => rowIndex < _rows.length ? _rows[rowIndex] : null;

  /// supportRefresh return true if support refresh
  bool get supportRefresh => dataRefresher != null && dataComparator != null && loaded;

  /// supportRemove return true if support remove selected rows
  bool get supportRemove => dataRemover != null && loaded;

  /// hasFirstPage return true if user can click first page
  bool get hasFirstPage => hasPrevPage;

  /// hasPrevPage return true if user can click prev page
  bool get hasPrevPage => !_busy && loaded && _pageIndex > 0;

  /// hasLastPage return true if user can click last page
  bool get hasLastPage => !_busy && loaded && status == PagedDataSourceStatus.end && _pageIndex < pageCount - 1;

  /// hasNextPage return true if user can click next page
  bool get hasNextPage {
    if (_busy || !loaded) {
      return false;
    }
    if (status != PagedDataSourceStatus.end) {
      return true;
    }
    return _pageIndex < pageCount - 1;
  }

  /// nextPage return true if load data
  ///
  ///     await nextPage(context);
  ///
  Future<void> nextPage(BuildContext context) async {
    await loadMoreRow(context, to: _pageIndex + 1);
    _pageIndex++;
    if (_pageIndex >= pageCount) {
      _pageIndex = pageCount - 1;
    }
    notifyListeners();
  }

  /// prevPage return true if page changed
  ///
  ///     final changed = await prevPage(context);
  ///
  Future<bool> prevPage(BuildContext context) async {
    if (_pageIndex > 0) {
      _pageIndex--;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// firstPage return true if page changed
  ///
  ///     final changed = await firstPage(context);
  ///
  Future<bool> firstPage(BuildContext context) async {
    if (_pageIndex > 0) {
      _pageIndex = 0;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// lastPage return true if page changed
  ///
  ///     final changed = await lastPage(context);
  ///
  Future<bool> lastPage(BuildContext context) async {
    if (_pageIndex < pageCount - 1) {
      _pageIndex = pageCount - 1;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// rowsPerPage return current rows per page
  int get rowsPerPage => _rowsPerPage;

  /// setRowsPerPage set rows per page and change page index to 0
  ///
  ///     await setRowsPerPage(context,20);
  ///
  Future<void> setRowsPerPage(BuildContext context, value) async {
    _pageIndex = 0;
    _rowsPerPage = value;
    await loadMoreRow(context);
    await saveToCache(context); // may need save when rowsPerPage changed
  }

  /// paging return text page info like '1-10' of 19
  String pagingInfo(BuildContext context) {
    if (status == PagedDataSourceStatus.notLoad) {
      return '';
    }
    int start = _pageIndex * _rowsPerPage;
    int end = start + getRowCountByPage(_pageIndex);
    if (status == PagedDataSourceStatus.end) {
      return '${start + 1} - $end ' + context.i18n.pagingCount.replaceAll('%1', _rows.length.toString());
    }
    return '${start + 1} - $end ' + context.i18n.pagingMany;
  }

  /// selectAll select all row
  void selectAll(bool? selected) {
    selected = selected ?? false;
    _selectedRows.clear();
    if (selected) {
      _selectedRows.addAll(_rows);
    }
    notifyListeners();
  }

  /// select a row
  void select(int rowIndex, bool? selected) {
    selected = selected ?? false;
    final row = _rows[rowIndex];
    if (selected) {
      if (!_selectedRows.contains(row)) {
        _selectedRows.add(row);
      }
    } else {
      _selectedRows.remove(row);
    }
    notifyListeners();
  }

  /// selectedRowsIsEmpty return true when selected rows is empty
  bool get selectedRowsIsEmpty => _selectedRows.isEmpty;

  /// selectedRowsLength return selected rows length
  int get selectedRowsLength => _selectedRows.length;

  /// isSelected return true when row is selected
  bool isSelected(int rowIndex) {
    final row = _rows[rowIndex];
    return _selectedRows.contains(row);
  }

  /// deleteSelected remove selected rows
  Future<bool> deleteSelected(BuildContext context) async {
    if (dataRemover != null) {
      _notifyBusy(true);
      try {
        bool result = await dataRemover!(context, _selectedRows);
        if (result) {
          for (T obj in _selectedRows) {
            _rows.remove(obj);
          }
          _selectedRows.clear();
          if (_pageIndex > pageCount - 1) {
            _pageIndex = pageCount - 1;
          }
          if (_pageIndex == pageCount - 1) {
            await loadMoreRow(context, to: _pageIndex);
          }
          return true;
        }
      } finally {
        _notifyBusy(false);
      }
    }
    return false;
  }
}
