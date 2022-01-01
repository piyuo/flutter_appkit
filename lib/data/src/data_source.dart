import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';

class DataSource<T extends pb.Object> extends ChangeNotifier {
  DataSource({
    BuildContext? context,
    required String id,
    required DataLoader<T> dataLoader,
    this.onRowsChanged,
  }) {
    _dataset = Dataset(id: id, dataLoader: dataLoader, onDataChanged: onDataChanged);
    if (context != null) {
      init(context);
    }
  }

  /// init data source with cache or data loader
  ///
  ///     await init(context);
  ///
  Future<void> init(BuildContext context) async {
    _notifyBusy(true);
    try {
      await _dataset.init();
      await _dataset.refresh(context, _rowsPerPage);
    } finally {
      _notifyBusy(false);
    }
  }

  /// _rows keep all cached rows
  late Dataset<T> _dataset;

  /// onRowsChange is called when rows are changed
  final VoidCallback? onRowsChanged;

  /// _selectedRows keep all selected rows
  final List<T> _selectedRows = [];

  /// selectedRows keep all selected rows
  List<T> get selectedRows => _selectedRows;

  /// currentRows export cached rows for Test
  List<T> get rows => _dataset.rows.getRange(_pageIndex, _pageIndex + rowsPerPage).toList();

  bool get noNeedRefresh => _dataset.noNeedRefresh;

  bool get noMoreData => _dataset.noMoreData;

  /// _rowsPerPage is current rows per page
  int _rowsPerPage = 10;

  /// _isBusy return true if data source is busy loading data
  bool _isBusy = false;

  /// isBusy return true if data source is busy loading data
  bool get isBusy => _isBusy;

  /// _pageIndex is current page index
  int _pageIndex = 0;

  /// pageCount return total page count
  int get pageCount {
    if (_dataset.isEmpty) {
      return 1;
    }
    return (_dataset.length / _rowsPerPage).ceil();
  }

  /// isLastPage return true if current page is last page
  bool get isLastPage => _dataset.noMoreData || _pageIndex == pageCount - 1;

  /// _notifyBusy set busy value and notify listener
  void _notifyBusy(bool value) {
    if (value != _isBusy) {
      _isBusy = value;
      notifyListeners();
    }
  }

  /// onDataChanged called when data changed
  @visibleForTesting
  void onDataChanged() {
    // remove not exists selected rows
    for (int i = _selectedRows.length - 1; i >= 0; i--) {
      final selected = _selectedRows[i];
      if (!_dataset.contains(selected)) {
        _selectedRows.remove(selected);
      }
    }
    onRowsChanged?.call();
  }

  /// hasFirstPage return true if user can click first page
  bool get hasFirstPage => hasPrevPage;

  /// hasPrevPage return true if user can click prev page
  bool get hasPrevPage => !_isBusy && _pageIndex > 0;

  /// hasLastPage return true if user can click last page
  bool get hasLastPage => !_isBusy && _dataset.noMoreData && _pageIndex < pageCount - 1;

  /// hasNextPage return true if user can click next page
  bool get hasNextPage {
    if (_isBusy) {
      return false;
    }
    if (!_dataset.noMoreData) {
      return true;
    }
    return _pageIndex < pageCount - 1;
  }

  /// nextPage return true if load data
  ///
  ///     await nextPage(context);
  ///
  Future<void> nextPage(BuildContext context) async => await gotoPage(context, _pageIndex++);

  /// prevPage return true if page changed
  ///
  ///     await prevPage(context);
  ///
  Future<void> prevPage(BuildContext context) async => await gotoPage(context, _pageIndex--);

  /// firstPage return true if page changed
  ///
  ///     await firstPage(context);
  ///
  Future<void> firstPage(BuildContext context) async => await gotoPage(context, 0);

  /// lastPage return true if page changed
  ///
  ///     await lastPage(context);
  ///
  Future<void> lastPage(BuildContext context) async => await gotoPage(context, pageCount - 1);

  /// gotoPage goto specified page, load more page if needed
  ///
  ///     await gotoPage(context,2);
  ///
  Future<void> gotoPage(BuildContext context, int index) async {
    _notifyBusy(true);
    try {
      if (index >= pageCount && !_dataset.noMoreData) {
        await _dataset.more(context, _rowsPerPage);
        _pageIndex = pageCount;
        return;
      }
      _pageIndex = index;
      if (_pageIndex < 0) {
        _pageIndex = 0;
      }
      if (_pageIndex >= pageCount) {
        _pageIndex = pageCount - 1;
      }
    } finally {
      _notifyBusy(false);
    }
  }

  /// setRowsPerPage set rows per page and change page index to 0
  ///
  ///     await setRowsPerPage(context,20);
  ///
  Future<void> setRowsPerPage(BuildContext context, int value) async {
    _notifyBusy(true);
    try {
      if (value > _dataset.length && !_dataset.noMoreData) {
        await _dataset.more(context, value - _dataset.length);
      }
      _pageIndex = 0;
      _rowsPerPage = value;
    } finally {
      _notifyBusy(false);
    }
  }

  /// rowsPerPage return current rows per page
  int get rowsPerPage => _rowsPerPage;

  /// refresh cached rows
  ///
  ///     await refreshNewRow(context);
  ///
  Future<void> refresh(BuildContext context) async {
    _notifyBusy(true);
    try {
      await _dataset.refresh(context, _rowsPerPage);
    } finally {
      _notifyBusy(false);
    }
  }

  /// length return current page row count
  ///
  ///     dataSource.length;
  ///
  int get length => _dataset.length;

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
      return _dataset.length - pageIndex * _rowsPerPage;
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
  T? row(int rowIndex) => rowIndex < _dataset.length ? _dataset.rows[rowIndex] : null;

  /// paging return text page info like '1-10' of 19
  String pagingInfo(BuildContext context) {
    int start = _pageIndex * _rowsPerPage;
    int end = start + getRowCountByPage(_pageIndex);
    if (_dataset.noMoreData) {
      return '${start + 1} - $end ' + context.i18n.pagingCount.replaceAll('%1', _dataset.length.toString());
    }
    return '${start + 1} - $end ' + context.i18n.pagingMany;
  }

  /// selectAll select all row
  void selectAll(bool? selected) {
    selected = selected ?? false;
    _selectedRows.clear();
    if (selected) {
      _selectedRows.addAll(_dataset.rows);
    }
    notifyListeners();
  }

  /// select a row
  void select(int rowIndex, bool? selected) {
    selected = selected ?? false;
    final row = _dataset.rows[rowIndex];
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
    final row = _dataset.rows[rowIndex];
    return _selectedRows.contains(row);
  }
}
