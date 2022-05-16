import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'dataset.dart';

/// DataViewState is state of data view
enum DataViewState {
  initial, // initial state
  refreshing, // refresh new data
  loading, // loading more data
  ready, // ready to show data
}

/// DataViewLoader can refresh or load more data by anchor and limit
/// ```dart
/// loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
///   return List.generate(returnCount, (i) => sample.Person(entity: pb.Entity(id: '$returnID-$i')));
/// },
/// ```
typedef DataViewLoader<T> = Future<List<T>> Function(
    BuildContext context, bool isRefresh, int limit, google.Timestamp? anchorTime, String? anchorId);

/// DataProvider read data save to local, manage paging and select row
/// ```dart
/// final ds = DataProvider<sample.Person>(
///   MemoryRam(dataBuilder: () => sample.Person()),
///   dataBuilder: () => sample.Person(),
///   loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async =>
///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
/// );
/// await ds.start(testing.Context());
/// ```
abstract class DataView<T extends pb.Object> with ChangeNotifier {
  /// DataProvider read data save to local, manage paging and select row
  /// ```dart
  /// final ds = DataProvider<sample.Person>(
  ///   MemoryRam(dataBuilder: () => sample.Person()),
  ///   dataBuilder: () => sample.Person(),
  ///   loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async =>
  ///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
  /// );
  /// await ds.start(testing.Context());
  /// ```
  DataView(
    this.memory, {
    BuildContext? context,
    required this.loader,
    required this.dataBuilder,
    this.onReady,
  }) {
    if (context != null) {
      open(context);
    }
  }

  /// dataBuilder build data
  final pb.Builder<T> dataBuilder;

  /// loader can refresh or load more data by anchor and limit
  final DataViewLoader<T> loader;

  /// onReady called when data source is opened/refreshed and ready to use
  final VoidCallback? onReady;

  /// state is the state of data view
  DataViewState state = DataViewState.initial;

  /// memory keep all rows in memory
  Dataset<T> memory;

  /// selectedRows keep all selected rows
  List<T> selectedRows = [];

  /// displayRows is rows to display
  List<T> displayRows = [];

  /// isDisplayRowsFullPage return true if displayRows is full of page
  bool get isDisplayRowsFullPage => displayRows.length == rowsPerPage;

  /// length return rows length
  /// ```dart
  /// var len=ds.length;
  /// ```
  int get length => memory.length;

  /// isEmpty return rows is empty
  bool get isEmpty => memory.isEmpty;

  /// isNotEmpty return rows is not empty
  bool get isNotEmpty => memory.isNotEmpty;

  /// noRefresh return true if no refresh need
  bool get noRefresh => memory.noRefresh;

  /// setNoRefresh set true mean  no need to refresh data, it will only use data in dataset
  Future<void> setNoRefresh(BuildContext context, value) async => memory.setNoRefresh(context, value);

  /// noMore return true if no more data to add
  bool get noMore => memory.noMore;

  /// rowsPerPage return rows per page
  int get rowsPerPage => memory.rowsPerPage;

  /// setMemory set new memory to data set
  /// ```dart
  /// ds.setMemory(context,memory);
  /// ```
  void setMemory(BuildContext context, Dataset<T> source) {
    memory = source;
  }

  /// fill display rows
  /// ```dart
  /// await ds.fill();
  /// ```
  Future<void> fill();

  /// pageInfo return text page info like '1-10 of many'
  /// ```dart
  /// expect(ds.pageInfo(testing.Context()), '1-10 of many');
  /// ```
  String pageInfo(BuildContext context);

  /// open dataset and refresh data, it will automatically called when data view create with context
  /// ```dart
  /// await ds.open(context);
  /// ```
  Future<void> open(BuildContext context) async {
    try {
      await memory.open();
      await refresh(context);
      onReady?.call();
    } finally {
      notifyState(DataViewState.ready);
    }
  }

  /// dispose dataset
  @override
  void dispose() {
    memory.close();
    super.dispose();
  }

  /// notifyState change state and notify listener
  void notifyState(DataViewState newState) {
    state = newState;
    notifyListeners();
  }

  /// onRefresh reset memory but not on full view mode, return true if reset dataset
  Future<bool> onRefresh(BuildContext context, List<T> downloadRows) async {
    bool isReset = false;
    if (memory.isEmpty && downloadRows.length < memory.rowsPerPage) {
      await memory.setNoMore(context, true);
    }
    if (downloadRows.length == rowsPerPage) {
      // if download length == limit, it means there is more data and we need expired all our cache to start over
      memory.reset(context);
      selectedRows.clear();
      isReset = true;
    }
    await memory.insert(context, downloadRows);
    return isReset;
  }

  /// refresh seeking new data from data loader, return true if has new data
  /// ```dart
  /// await ds.refresh(context);
  /// ```
  Future<bool> refresh(BuildContext context) async {
    if (memory.noRefresh) {
      debugPrint('[data_view] no refresh already');
      return false;
    }
    notifyState(DataViewState.refreshing);
    try {
      await memory.reload(); // someone may change memory so reload it
      T? anchor = await memory.first;
      final downloadRows = await loader(context, true, memory.rowsPerPage, anchor?.entityUpdateTime, anchor?.entityID);
      if (downloadRows.isNotEmpty) {
        debugPrint('[data_view] refresh ${downloadRows.length} rows');
      }
      bool isReset = await onRefresh(context, downloadRows);
      return isReset;
    } finally {
      notifyState(DataViewState.ready);
    }
  }

  /// more seeking more data from data loader, return true if has more data
  /// ```dart
  /// await ds.more(testing.Context(), 2);
  /// ```
  Future<bool> more(BuildContext context, int limit) async {
    if (memory.noMore) {
      debugPrint('[data_view] no more already');
      return false;
    }
    notifyState(DataViewState.loading);
    try {
      T? anchor = await memory.last;
      final downloadRows = await loader(context, false, limit, anchor?.entityUpdateTime, anchor?.entityID);
      if (downloadRows.length < limit) {
        debugPrint('[data_view] has no more data');
        await memory.setNoMore(context, true);
      }
      if (downloadRows.isNotEmpty) {
        await memory.add(context, downloadRows);
        await fill();
        return true;
      }
      return false;
    } finally {
      notifyState(DataViewState.ready);
    }
  }

  /// setRowsPerPage set rows per page and change page index to 0
  /// ```dart
  /// await setRowsPerPage(context, 20);
  /// ```
  Future<void> setRowsPerPage(BuildContext context, int value);

  /// isRowSelected return true when row is selected
  /// ```dart
  /// final selected = dataView.isRowSelected(dataView.displayRows.first);
  /// ```
  bool isRowSelected(T row) => selectedRows.contains(row);

  /// selectRows select rows
  /// ```dart
  /// selectRows([sample.Person(entity: pb.Entity(id: '5'))]);
  /// ```
  void selectRows(List<T> rows) {
    selectedRows.clear();
    rows.removeWhere((row) => !memory.isIDExists(row.entityID));
    selectedRows.addAll(rows);
    notifyListeners();
  }

  /// selectRow select a row
  /// ```dart
  /// selectRow(dataView.displayRows.first, true);
  /// ```
  void selectRow(T row, bool selected) {
    selectedRows.remove(row);
    if (selected && memory.isIDExists(row.entityID)) {
      selectedRows.add(row);
    }
    notifyListeners();
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await getRowByID('1');
  /// ```
  Future<T?> getRowByID(String id) async => await memory.read(id);
}
