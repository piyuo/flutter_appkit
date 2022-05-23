import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'dataset.dart';

/// DataViewLoader can refresh or load more data by anchor and limit
/// ```dart
/// loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
///   return List.generate(returnCount, (i) => sample.Person(entity: pb.Entity(id: '$returnID-$i')));
/// },
/// ```
typedef DataViewLoader<T> = Future<List<T>> Function(
    BuildContext context, bool isRefresh, int limit, google.Timestamp? anchorTime, String? anchorId);

/// DataView read data save to local, manage paging and select row
/// ```dart
/// final dataView = DataView<sample.Person>(
///   DatasetRam(dataBuilder: () => sample.Person()),
///   dataBuilder: () => sample.Person(),
///   loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async =>
///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
/// );
/// await dataView.open(testing.Context());
/// ```
abstract class DataView<T extends pb.Object> {
  /// DataView read data save to local, manage paging and select row
  /// ```dart
  /// final dataView = DataView<sample.Person>(
  ///   DatasetRam(dataBuilder: () => sample.Person()),
  ///   dataBuilder: () => sample.Person(),
  ///   loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async =>
  ///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
  /// );
  /// await dataView.open(testing.Context());
  /// ```
  DataView(
    this.dataset, {
    required this.loader,
    required this.dataBuilder,
  });

  /// dataBuilder build data
  final pb.Builder<T> dataBuilder;

  /// loader can refresh or load more data by anchor and limit
  final DataViewLoader<T> loader;

  /// dataset keep all rows in dataset
  Dataset<T> dataset;

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
  int get length => dataset.length;

  /// isEmpty return rows is empty
  bool get isEmpty => dataset.isEmpty;

  /// isNotEmpty return rows is not empty
  bool get isNotEmpty => dataset.isNotEmpty;

  /// noRefresh return true if no refresh need
  bool get noRefresh => dataset.noRefresh;

  /// setNoRefresh set true mean  no need to refresh data, it will only use data in dataset
  Future<void> setNoRefresh(BuildContext context, value) async => dataset.setNoRefresh(context, value);

  /// noMore return true if no more data to add
  bool get noMore => dataset.noMore;

  /// rowsPerPage return rows per page
  int get rowsPerPage => dataset.rowsPerPage;

  /// setDataset set new dataset to data set
  /// ```dart
  /// ds.setDataset(context,dataset);
  /// ```
  void setDataset(BuildContext context, Dataset<T> source) {
    dataset = source;
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

  /// load dataset
  @mustCallSuper
  Future<void> load(BuildContext context) async {
    selectedRows = [];
    displayRows = [];
    await dataset.load();
  }

  /// onRefresh reset dataset but not on full view mode, return true if reset dataset
  Future<bool> onRefresh(BuildContext context, List<T> downloadRows) async {
    bool isReset = false;
    if (dataset.isEmpty && downloadRows.length < dataset.rowsPerPage) {
      await dataset.setNoMore(context, true);
    }
    if (downloadRows.length == rowsPerPage) {
      // if download length == limit, it means there is more data and we need expired all our cache to start over
      dataset.reset();
      selectedRows.clear();
      isReset = true;
    }
    await dataset.insert(context, downloadRows);
    return isReset;
  }

  /// refresh seeking new data from data loader, return true if has new data
  /// ```dart
  /// await ds.refresh(context);
  /// ```
  Future<bool> refresh(BuildContext context) async {
    if (dataset.noRefresh) {
      debugPrint('[data_view] no refresh already');
      return false;
    }
    await dataset.load(); // someone may change dataset so reload it
    T? anchor = await dataset.first;
    final downloadRows = await loader(context, true, dataset.rowsPerPage, anchor?.entityUpdateTime, anchor?.entityID);
    if (downloadRows.isNotEmpty) {
      debugPrint('[data_view] refresh ${downloadRows.length} rows');
    }
    bool isReset = await onRefresh(context, downloadRows);
    return isReset;
  }

  /// more seeking more data from data loader, return true if has more data
  /// ```dart
  /// await ds.more(testing.Context(), 2);
  /// ```
  Future<bool> more(BuildContext context, int limit) async {
    if (dataset.noMore) {
      debugPrint('[data_view] no more already');
      return false;
    }
    T? anchor = await dataset.last;
    final downloadRows = await loader(context, false, limit, anchor?.entityUpdateTime, anchor?.entityID);
    if (downloadRows.length < limit) {
      debugPrint('[data_view] has no more data');
      await dataset.setNoMore(context, true);
    }
    if (downloadRows.isNotEmpty) {
      await dataset.add(context, downloadRows);
      await fill();
      return true;
    }
    return false;
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
    rows.removeWhere((row) => !dataset.isIDExists(row.entityID));
    selectedRows.addAll(rows);
  }

  /// selectRow select a row
  /// ```dart
  /// selectRow(dataView.displayRows.first, true);
  /// ```
  void selectRow(T row, bool selected) {
    selectedRows.remove(row);
    if (selected && dataset.isIDExists(row.entityID)) {
      selectedRows.add(row);
    }
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await getRowByID('1');
  /// ```
  Future<T?> getRowByID(String id) async => await dataset.read(id);

  /// delete selected item in dataset
  @mustCallSuper
  Future<void> delete(BuildContext context) async {
    if (selectedRows.isEmpty) {
      return;
    }
    await dataset.delete(context, selectedRows);
  }

  /// update item in dataset
  @mustCallSuper
  Future<void> update(BuildContext context, T row) async {
    await dataset.update(context, row);
  }
}
