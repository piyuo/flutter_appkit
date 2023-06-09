import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/google/google.dart' as google;
import 'dataset.dart';

/// DataViewLoader can refresh or load more data by anchor and limit
/// ```dart
/// loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
///   return List.generate(returnCount, (i) => sample.Person(entity: pb.Entity(id: '$returnID-$i')));
/// },
/// ```
typedef DataViewLoader<T> = Future<List<T>> Function(
    bool isRefresh, int limit, google.Timestamp? anchorTime, String? anchorId);

/// DataView read data save to local, manage paging and select row,
abstract class DataView<T extends pb.Object> {
  /// ```dart
  /// final dataView = DataView<sample.Person>(
  ///   DatasetRam(
  ///   loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async =>
  ///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
  /// );
  /// await dataView.open(testing.Context());
  /// ```
  DataView(
    this.dataset, {
    required this.loader,
  });

  /// loader can refresh or load more data by anchor and limit
  final DataViewLoader<T> loader;

  /// dataset keep all rows in dataset
  Dataset<T> dataset;

  /// selectedRows keep all selected item id
  List<String> selectedIDs = [];

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
  Future<void> setNoRefresh(value) async => dataset.setNoRefresh(value);

  /// noMore return true if no more data to add
  bool get noMore => dataset.noMore;

  /// rowsPerPage return rows per page
  int get rowsPerPage => dataset.rowsPerPage;

  /// setDataset set new dataset to data set
  /// ```dart
  /// ds.setDataset(context,dataset);
  /// ```
  void setDataset(Dataset<T> source) {
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
  Future<void> load() async {
    await dataset.load();
  }

  /// onInsert called after insert row
  Future<void> onInsert(List<T> list) async {
    await fill();
  }

  /// insert data to dataset
  @mustCallSuper
  Future<void> insert(List<T> list) async {
    if (list.isNotEmpty) {
      await dataset.insert(list);
      await onInsert(list);
    }
  }

  /// onAdd called after add row
  Future<void> onAdd(List<T> list) async {
    await fill();
  }

  /// add data to dataset
  @mustCallSuper
  Future<void> add(List<T> list) async {
    if (list.isNotEmpty) {
      await dataset.add(list);
      await onAdd(list);
    }
  }

  /// onDelete called after delete row
  Future<void> onDelete(List<String> list) async {
    await fill();
  }

  /// delete data to dataset
  @mustCallSuper
  Future<void> delete(List<String> list) async {
    if (list.isNotEmpty) {
      await dataset.delete(list);
      await onDelete(list);
    }
  }

  /// delete data to dataset
  @mustCallSuper
  Future<void> deleteRows(List<T> list) async {
    List<String> ids = list.map((row) => row.id).toList();
    await dataset.delete(ids);
    await onDelete(ids);
  }

  /// onReset called after reset
  Future<void> onReset() async {
    await fill();
  }

  /// reset dataset
  @mustCallSuper
  Future<void> reset() async {
    await dataset.reset();
    await onReset();
  }

  /// onSetRowsPerPage called setRowsPerPage
  Future<void> onSetRowsPerPage(int value) async {
    await fill();
  }

  /// setRowsPerPage set dataset rows per page
  @mustCallSuper
  Future<void> setRowsPerPage(int value) async {
    await dataset.setRowsPerPage(value);
    await onSetRowsPerPage(value);
  }

  /// onRefresh reset dataset but not on full view mode, return true if reset dataset
  Future<bool> onRefresh(List<T> downloadRows) async {
    bool isReset = false;
    if (dataset.isEmpty && downloadRows.length < dataset.rowsPerPage) {
      await dataset.setNoMore(true);
    }
    if (downloadRows.length == rowsPerPage) {
      // if download length == limit, it means there is more data and we need expired all our cache to start over
      dataset.reset();
      selectedIDs.clear();
      isReset = true;
    }
    if (downloadRows.isNotEmpty) {
      // insert will call fill()
      await insert(downloadRows);
    } else {
      await fill();
    }
    return isReset;
  }

  /// refresh seeking new data from data loader, return true if reset
  /// ```dart
  /// await ds.refresh(context);
  /// ```
  Future<bool> refresh() async {
    if (dataset.noRefresh) {
      debugPrint('[data_view] no refresh already');
      return false;
    }
    await dataset.load(); // someone may change dataset so reload it
    T? anchor = await dataset.first;
    final downloadRows = await loader(true, dataset.rowsPerPage, anchor?.timestamp, anchor?.id);
    if (downloadRows.isNotEmpty) {
      debugPrint('[data_view] refresh ${downloadRows.length} rows');
    }
    bool isReset = await onRefresh(downloadRows);
    return isReset;
  }

  /// more seeking more data from data loader, return true if has more data
  /// ```dart
  /// await ds.more(testing.Context(), 2);
  /// ```
  Future<bool> more(int limit) async {
    if (dataset.noMore) {
      debugPrint('[data_view] no more already');
      return false;
    }
    T? anchor = await dataset.last;
    final downloadRows = await loader(false, limit, anchor?.timestamp, anchor?.id);
    if (downloadRows.length < limit) {
      debugPrint('[data_view] has no more data');
      await dataset.setNoMore(true);
    }
    if (downloadRows.isNotEmpty) {
      await add(downloadRows);
      return true;
    }
    return false;
  }

  /// isRowSelected return true when row is selected
  /// ```dart
  /// final selected = dataView.isRowSelected(dataView.displayRows.first);
  /// ```
  bool isRowSelected(T row) => selectedIDs.contains(row.id);

  /// selectedCount return selected rows count
  int get selectedCount => selectedIDs.length;

  /// hasSelectedRows return true when has selected rows
  bool get hasSelectedRows => selectedIDs.isNotEmpty;

  /// setSelectedRows select rows
  /// ```dart
  /// setSelectedRows([sample.Person(entity: pb.Entity(id: '5'))]);
  /// ```
  void setSelectedRows(List<T> rows) {
    selectedIDs.clear();
    rows.removeWhere((row) => !dataset.isIDExists(row.id));
    selectedIDs.addAll(rows.map((row) => row.id));
  }

  /// getSelectedRows return selected rows
  /// ```dart
  /// getSelectedRows();
  /// ```
  List<T> getSelectedRows() {
    final rows = <T>[];
    for (final row in displayRows) {
      if (selectedIDs.contains(row.id)) {
        rows.add(row);
      }
    }
    return rows;
  }

  /// setSelectedRows select rows
  /// ```dart
  /// setSelectedRows(['5']);
  /// ```
  void setSelected(List<String> ids) {
    selectedIDs.clear();
    ids.removeWhere((id) => !dataset.isIDExists(id));
    selectedIDs.addAll(ids);
  }

  /// selectRow select a row
  /// ```dart
  /// selectRow(dataView.displayRows.first, true);
  /// ```
  void selectRow(T row, bool selected) {
    selectedIDs.remove(row.id);
    if (selected && dataset.isIDExists(row.id)) {
      selectedIDs.add(row.id);
    }
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await getRowByID('1');
  /// ```
  Future<T?> getRowByID(String id) async => await dataset.read(id);
}
