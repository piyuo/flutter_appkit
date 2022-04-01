import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'memory.dart';
import 'db.dart';
import 'paginator.dart';

/// DatasetLoader can refresh or load more data by anchor and limit
/// ```dart
/// loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
///   return List.generate(returnCount, (i) => sample.Person(entity: pb.Entity(id: '$returnID-$i')));
/// },
/// ```
typedef DatasetLoader<T> = Future<List<T>> Function(
    BuildContext context, bool isRefresh, int limit, google.Timestamp? anchorTime, String? anchorId);

/// Dataset read data save to local, manage paging and select row
/// ```dart
/// final ds = Dataset<sample.Person>(
///   MemoryRam(dataBuilder: () => sample.Person()),
///   dataBuilder: () => sample.Person(),
///   loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async =>
///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
/// );
/// await ds.start(testing.Context());
/// ```
class Dataset<T extends pb.Object> with ChangeNotifier {
  /// Dataset read data save to local, manage paging and select row
  /// ```dart
  /// final ds = Dataset<sample.Person>(
  ///   MemoryRam(dataBuilder: () => sample.Person()),
  ///   dataBuilder: () => sample.Person(),
  ///   loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async =>
  ///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
  /// );
  /// await ds.start(testing.Context());
  /// ```
  Dataset(
    this._memory, {
    BuildContext? context,
    required this.loader,
    required this.dataBuilder,
    this.alwaysDisplayAll = false,
    this.onReady,
  }) {
    if (context != null) {
      start(context);
    }
  }

  /// dataBuilder build data
  final pb.Builder<T> dataBuilder;

  /// loader can refresh or load more data by anchor and limit
  final DatasetLoader<T> loader;

  /// onReady called when data source is opened/refreshed and ready to use
  final VoidCallback? onReady;

  /// state is the state of dataset
  DataState state = DataState.initial;

  /// _memory keep all rows in memory
  final Memory<T> _memory;

  /// selectedRows keep all selected rows
  List<T> selectedRows = [];

  /// displayRows is rows to display
  List<T> displayRows = [];

  /// pageIndex is current page index
  int pageIndex = 0;

  /// alwaysDisplayAll will display all data in memory
  bool alwaysDisplayAll;

  /// isDisplayRowsFullPage return true if displayRows is full of page
  bool get isDisplayRowsFullPage => displayRows.length == rowsPerPage;

  /// length return rows is empty
  /// ```dart
  /// var len=ds.length;
  /// ```
  int get length => _memory.length;

  /// innerMemory can get _memory for child
  @protected
  Memory<T> get innerMemory => _memory;

  /// noMoreData return true if no more data to add
  bool get noMoreData => _memory.noMoreData;

  /// rowsPerPage return rows per page
  int get rowsPerPage => _memory.rowsPerPage;

  /// isEmpty return rows is empty
  bool get isEmpty => _memory.isEmpty;

  /// isNotEmpty return rows is not empty
  bool get isNotEmpty => _memory.isNotEmpty;

  /// start when data source create with context
  /// ```dart
  /// await ds.start(context);
  /// ```
  Future<void> start(BuildContext context) async {
    try {
      await _memory.open();
      await refresh(context);
      onReady?.call();
    } finally {
      notifyState(DataState.ready);
    }
  }

  /// close dataset
  /// ```dart
  /// await ds.close();
  /// ```
  @visibleForTesting
  Future<void> close() async => await _memory.close();

  /// notifyState change state and notify listener
  void notifyState(DataState newState) {
    state = newState;
    notifyListeners();
  }

  /// onBeforeRefresh called before refresh
  void onBeforeRefresh(List<T> list) {
    if (isEmpty && list.length < rowsPerPage) {
      _memory.noMoreData = true;
    }
    if (list.length == rowsPerPage) {
      // if download length == limit, it means there is more data and we need expired all our cache to start over
      _memory.clear();
    }
  }

  /// refresh seeking new data from data loader, return true if has new data
  /// ```dart
  /// await ds.refresh(context);
  /// ```
  Future<bool> refresh(BuildContext context) async {
    notifyState(DataState.refreshing);
    try {
      T? anchor = await _memory.first;
      final downloadRows = await loader(context, true, _memory.rowsPerPage, anchor?.entityUpdateTime, anchor?.entityID);
      onBeforeRefresh(downloadRows);
      if (_memory.isEmpty && downloadRows.length < _memory.rowsPerPage) {
        _memory.noMoreData = true;
      }
      if (downloadRows.isNotEmpty) {
        debugPrint('[dataset] refresh ${downloadRows.length} rows');
        await _memory.insert(downloadRows);
        await gotoPage(context, 0);
        return true;
      }
      return false;
    } finally {
      notifyState(DataState.ready);
    }
  }

  /// more seeking more data from data loader, return true if has more data
  /// ```dart
  /// await ds.more(testing.Context(), 2);
  /// ```
  Future<bool> more(BuildContext context, int limit) async {
    if (_memory.noMoreData) {
      debugPrint('[dataset] no more already');
      return false;
    }
    notifyState(DataState.loading);
    try {
      T? anchor = await _memory.last;
      final downloadRows = await loader(context, false, limit, anchor?.entityUpdateTime, anchor?.entityID);
      if (downloadRows.length < limit) {
        debugPrint('[dataset] has no more data');
        _memory.noMoreData = true;
      }
      if (downloadRows.isNotEmpty) {
        await _memory.add(downloadRows);
        return true;
      }
      return false;
    } finally {
      notifyState(DataState.ready);
    }
  }

  /// fill display rows
  /// ```dart
  /// await ds.fill();
  /// ```
  Future<void> fill() async {
    displayRows.clear();
    List<T>? range;
    if (alwaysDisplayAll) {
      range = await _memory.allRows;
    } else {
      final paginator = Paginator(rowCount: _memory.length, rowsPerPage: _memory.rowsPerPage);
      range = await _memory.subRows(paginator.getBeginIndex(pageIndex), paginator.getEndIndex(pageIndex));
    }
    if (range == null) {
      notifyState(DataState.dataMissing);
      return;
    }
    displayRows.addAll(range);
  }

  /// isFirstPage return true if it is first page
  bool get isFirstPage => pageIndex == 0;

  /// hasPrevPage return true if user can click prev page
  bool get hasPrevPage => pageIndex > 0;

  /// hasNextPage return true if user can click next page
  bool get hasNextPage {
    final paginator = Paginator(rowCount: _memory.length, rowsPerPage: _memory.rowsPerPage);
    return noMoreData ? pageIndex < paginator.pageCount - 1 : true;
  }

  /// nextPage return true if load data
  ///
  ///     await nextPage(context);
  ///
  Future<void> nextPage(BuildContext context) async => await gotoPage(context, pageIndex + 1);

  /// prevPage return true if page changed
  ///
  ///     await prevPage();
  ///
  Future<void> prevPage(BuildContext context) async => await gotoPage(context, pageIndex - 1);

  /// loadMoreBeforeGotoPage load more data before goto page
  Future<void> loadMoreBeforeGotoPage(BuildContext context, int index) async {
    final expectRowsCount = length - index * rowsPerPage;
    if (expectRowsCount < rowsPerPage && !noMoreData) {
      //the page is not fill with enough data, load more data
      await more(context, rowsPerPage - expectRowsCount);
    }
  }

  /// gotoPage goto specified page, load more page if needed
  /// ```dart
  /// await gotoPage(context, 2);
  /// ```
  Future<void> gotoPage(BuildContext context, int index) async {
    await loadMoreBeforeGotoPage(context, index);
    try {
      final paginator = Paginator(rowCount: _memory.length, rowsPerPage: _memory.rowsPerPage);
      pageIndex = index;
      if (pageIndex < 0) {
        pageIndex = 0;
      }
      if (pageIndex >= paginator.pageCount) {
        pageIndex = paginator.pageCount - 1;
      }
      await fill();
    } finally {
      notifyListeners();
    }
  }

  /// setRowsPerPage set rows per page and change page index to 0
  /// ```dart
  /// await setRowsPerPage(context, 20);
  /// ```
  Future<void> setRowsPerPage(BuildContext context, int value) async {
    try {
      pageIndex = 0;
      _memory.rowsPerPage = value;
      _memory.save();
      await gotoPage(context, 0);
    } finally {
      notifyListeners();
    }
  }

  /// pagingInfo return text page info like '1-10 of many'
  /// ```dart
  /// expect(ds.pagingInfo(testing.Context()), '10 rows');
  /// ```
  String pagingInfo(BuildContext context) {
    if (alwaysDisplayAll) {
      return '${_memory.length} ' + context.i18n.pagingRows;
    }
    final paginator = Paginator(rowCount: _memory.length, rowsPerPage: _memory.rowsPerPage);
    final info = '${paginator.getBeginIndex(pageIndex) + 1} - ${paginator.getEndIndex(pageIndex)} ';
    if (noMoreData) {
      return info + context.i18n.pagingCount.replaceAll('%1', length.toString());
    }
    return info + context.i18n.pagingMany;
  }

  /// isRowSelected return true when row is selected
  /// ```dart
  /// final selected = ds.isRowSelected(dataSet.displayRows.first);
  /// ```
  bool isRowSelected(T row) => selectedRows.contains(row);

  /// selectRows select rows
  /// ```dart
  /// selectRows([sample.Person(entity: pb.Entity(id: '5'))]);
  /// ```
  void selectRows(List<T> rows) {
    selectedRows.clear();
    rows.removeWhere((row) => !_memory.isIDExists(row.entityID));
    selectedRows.addAll(rows);
    notifyListeners();
  }

  /// selectRow select a row
  /// ```dart
  /// selectRow(dataSet.displayRows.first, true);
  /// ```
  void selectRow(T row, bool selected) {
    selectedRows.remove(row);
    if (selected && _memory.isIDExists(row.entityID)) {
      selectedRows.add(row);
    }
    notifyListeners();
  }
}
