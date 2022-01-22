import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';
import 'data.dart';

class DataSource<T extends pb.Object> extends ChangeNotifier {
  DataSource({
    BuildContext? context,
    required String id,
    required DataLoader<T> dataLoader,
    required pb.Builder<T> dataBuilder,
    DataRemover<T>? dataRemover,
    this.onRowsChanged,
    int rowsPerPage = 10,
  }) {
    _rowsPerPage = rowsPerPage;
    _dataset = Dataset<T>(
      id: id,
      dataLoader: dataLoader,
      dataBuilder: dataBuilder,
      dataRemover: dataRemover,
      onDataChanged: onDataChanged,
    );
    if (context != null) {
      init(context);
    }
  }

  /// _rows keep all cached rows
  late Dataset<T> _dataset;

  /// onRowsChange is called when rows are changed
  final VoidCallback? onRowsChanged;

  /// _selectedRows keep all selected rows
  final List<T> selectedRows = [];

  /// pageRows return current page rows
  List<T> get pageRows => _dataset.rows.getRange(currentIndexStart, currentIndexEnd).toList();

  /// allRows return all rows
  List<T> get allRows => _dataset.rows;

  /// pageIndex return current page index
  int get pageIndex => _pageIndex;

  /// noNeedRefresh return true if no need to refresh
  bool get noNeedRefresh => _dataset.noNeedRefresh;

  /// noMoreData return true if no need to load more data
  bool get noMoreData => _dataset.noMoreData;

  /// isEmpty return true if dataset is empty
  bool get isEmpty => _dataset.isEmpty;

  /// isNotEmpty return true if dataset is not empty
  bool get isNotEmpty => _dataset.isNotEmpty;

  /// _rowsPerPage is current rows per page
  int _rowsPerPage = 10;

  /// rowsPerPage return current rows per page
  int get rowsPerPage => _rowsPerPage;

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
    return (_dataset.rows.length / _rowsPerPage).ceil();
  }

  /// currentIndexStart return start index in current page
  int get currentIndexStart => _pageIndex * _rowsPerPage;

  /// currentIndexEnd return end index in current page
  int get currentIndexEnd => currentIndexStart + currentRowCount;

  /// return row count in current page
  int get currentRowCount => getRowCountByPage(_pageIndex);

  /// isLastPage return true if current page is the last page
  bool get isLastPage => _dataset.noMoreData && _pageIndex == pageCount - 1;

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
    for (int i = selectedRows.length - 1; i >= 0; i--) {
      final selected = selectedRows[i];
      if (!_dataset.rows.contains(selected)) {
        selectedRows.remove(selected);
      }
    }
    onRowsChanged?.call();
  }

  /// nextPage return true if load data
  ///
  ///     await nextPage(context);
  ///
  Future<void> nextPage(BuildContext context) async => await gotoPage(context, _pageIndex + 1);

  /// prevPage return true if page changed
  ///
  ///     await prevPage(context);
  ///
  Future<void> prevPage(BuildContext context) async => await gotoPage(context, _pageIndex - 1);

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
  @visibleForTesting
  Future<void> gotoPage(BuildContext context, int index) async {
    _notifyBusy(true);
    try {
      final expectRowsCount = _dataset.rows.length - index * _rowsPerPage;
      if (expectRowsCount < _rowsPerPage && !_dataset.noMoreData) {
        //the page is not fill with enough data, load more data
        await _dataset.more(context, _rowsPerPage - expectRowsCount);
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
      _pageIndex = 0;
      _rowsPerPage = value;
      await gotoPage(context, 0);
    } finally {
      _notifyBusy(false);
    }
  }

  /// refresh cached rows
  ///
  ///     await refreshNewRow(context);
  ///
  Future<void> refresh(BuildContext context) async {
    _notifyBusy(true);
    try {
      _pageIndex = 0;
      await _dataset.refresh(context, _rowsPerPage);
    } finally {
      _notifyBusy(false);
    }
  }

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
      return _dataset.rows.length - pageIndex * _rowsPerPage;
    }
    return _rowsPerPage;
  }

  /// paging return text page info like '1-10' of 19
  String pagingInfo(BuildContext context) {
    if (_dataset.noMoreData) {
      return '${currentIndexStart + 1} - $currentIndexEnd ' +
          context.i18n.pagingCount.replaceAll('%1', _dataset.rows.length.toString());
    }
    return '${currentIndexStart + 1} - $currentIndexEnd ' + context.i18n.pagingMany;
  }

  /// isRowSelected return true when row is selected
  bool isRowSelected(T row) => selectedRows.contains(row);

  /// selectAllRows select all row
  void selectAllRows(bool selected) {
    selectedRows.clear();
    if (selected) {
      selectedRows.addAll(_dataset.rows);
    }
    notifyListeners();
  }

  /// selectPageRows select all row in current page
  void selectRows(bool selected) {
    selectedRows.clear();
    if (selected) {
      selectedRows.addAll(_dataset.rows.getRange(currentIndexStart, currentIndexEnd));
    }
    notifyListeners();
  }

  /// selectRow select a row
  void selectRow(T row, bool? selected) {
    selected = selected ?? false;
    if (selected) {
      if (!selectedRows.contains(row)) {
        selectedRows.add(row);
      }
    } else {
      selectedRows.remove(row);
    }
    notifyListeners();
  }

  /// delete item from dataset
  Future<void> deleteSelectedRows(BuildContext context) async {
    if (selectedRows.isNotEmpty) {
      final ids = selectedRows.map((row) => row.entityID).toList();
      _dataset.delete(context, ids);
    }
  }
}
