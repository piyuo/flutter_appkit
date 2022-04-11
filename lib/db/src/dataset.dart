import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'memory.dart';
import 'db.dart';

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
abstract class Dataset<T extends pb.Object> with ChangeNotifier {
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
    this.memory, {
    BuildContext? context,
    required this.loader,
    required this.dataBuilder,
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

  /// memory keep all rows in memory
  final Memory<T> memory;

  /// selectedRows keep all selected rows
  List<T> selectedRows = [];

  /// displayRows is rows to display
  List<T> displayRows = [];

  /// isDisplayRowsFullPage return true if displayRows is full of page
  bool get isDisplayRowsFullPage => displayRows.length == rowsPerPage;

  /// length return rows is empty
  /// ```dart
  /// var len=ds.length;
  /// ```
  int get length => memory.length;

  /// innerMemory can get _memory for child
  @protected
  Memory<T> get innerMemory => memory;

  /// noRefresh return true if no refresh need
  bool get noRefresh => memory.noRefresh;

  /// noRefresh set to true if no refresh need
  set noRefresh(value) => memory.noRefresh = value;

  /// noMore return true if no more data to add
  bool get noMore => memory.noMore;

  /// rowsPerPage return rows per page
  int get rowsPerPage => memory.rowsPerPage;

  /// isEmpty return rows is empty
  bool get isEmpty => memory.isEmpty;

  /// isNotEmpty return rows is not empty
  bool get isNotEmpty => memory.isNotEmpty;

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

  /// start when data source create with context
  /// ```dart
  /// await ds.start(context);
  /// ```
  Future<void> start(BuildContext context) async {
    try {
      await memory.open();
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
  Future<void> close() async => await memory.close();

  /// notifyState change state and notify listener
  void notifyState(DataState newState) {
    state = newState;
    notifyListeners();
  }

  /// onRefresh reset memory on dataset mode but not on table mode, return true if reset memory
  Future<bool> onRefresh(BuildContext context, List<T> downloadRows) async {
    bool isReset = false;
    if (memory.isEmpty && downloadRows.length < memory.rowsPerPage) {
      memory.noMore = true;
    }
    if (downloadRows.length == rowsPerPage) {
      // if download length == limit, it means there is more data and we need expired all our cache to start over
      memory.clear();
      selectedRows.clear();
      isReset = true;
    }
    await memory.insert(downloadRows);
    return isReset;
  }

  /// refresh seeking new data from data loader, return true if has new data
  /// ```dart
  /// await ds.refresh(context);
  /// ```
  Future<bool> refresh(BuildContext context) async {
    if (memory.noRefresh) {
      debugPrint('[dataset] no refresh already');
      return false;
    }
    notifyState(DataState.refreshing);
    try {
      T? anchor = await memory.first;
      final downloadRows = await loader(context, true, memory.rowsPerPage, anchor?.entityUpdateTime, anchor?.entityID);
      bool isReset = await onRefresh(context, downloadRows);
      if (downloadRows.isNotEmpty) {
        debugPrint('[dataset] refresh ${downloadRows.length} rows');
      }
      return isReset;
    } finally {
      notifyState(DataState.ready);
    }
  }

  /// more seeking more data from data loader, return true if has more data
  /// ```dart
  /// await ds.more(testing.Context(), 2);
  /// ```
  Future<bool> more(BuildContext context, int limit) async {
    if (memory.noMore) {
      debugPrint('[dataset] no more already');
      return false;
    }
    notifyState(DataState.loading);
    try {
      T? anchor = await memory.last;
      final downloadRows = await loader(context, false, limit, anchor?.entityUpdateTime, anchor?.entityID);
      if (downloadRows.length < limit) {
        debugPrint('[dataset] has no more data');
        memory.noMore = true;
      }
      if (downloadRows.isNotEmpty) {
        await memory.add(downloadRows);
        await fill();
        return true;
      }
      return false;
    } finally {
      notifyState(DataState.ready);
    }
  }

  /// setRowsPerPage set rows per page and change page index to 0
  /// ```dart
  /// await setRowsPerPage(context, 20);
  /// ```
  Future<void> setRowsPerPage(BuildContext context, int value);

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
    rows.removeWhere((row) => !memory.isIDExists(row.entityID));
    selectedRows.addAll(rows);
    notifyListeners();
  }

  /// selectRow select a row
  /// ```dart
  /// selectRow(dataSet.displayRows.first, true);
  /// ```
  void selectRow(T row, bool selected) {
    selectedRows.remove(row);
    if (selected && memory.isIDExists(row.entityID)) {
      selectedRows.add(row);
    }
    notifyListeners();
  }
}
