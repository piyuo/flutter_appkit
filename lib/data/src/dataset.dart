import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;

/// keyAll is key for keep all rows
const keyIndex = '__idx';

/// keyRowsPerPage is key for keep all rows per page
const keyRowsPerPage = '__rpp';

/// keyNoMoreData is key for no more data
const keyNoMore = '__nm';

/// keyNoRefresh is key for no refresh
const keyNoRefresh = '__nr';

/// Dataset keep rows for later use
/// ```dart
/// final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
/// await dataset.load();
/// ```
abstract class Dataset<T extends pb.Object> {
  /// Dataset keep rows for later use
  /// ```dart
  /// final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
  /// await dataset.load();
  /// ```
  Dataset({
    required this.objectBuilder,
    this.onInsert,
    this.onDelete,
    this.onLoad,
    this.onReset,
    this.onRowsPerPageChanged,
  });

  /// objectBuilder build data
  /// ```dart
  /// objectBuilder: () => sample.Person()
  /// ```
  final pb.Builder<T> objectBuilder;

  /// onLoad is callback when dataset is loaded
  Future<void> Function(BuildContext context, List<T> list)? onLoad;

  /// onInsert is callback when insert row
  Future<void> Function(BuildContext context, List<T> list)? onInsert;

  /// onDelete is callback when delete row
  Future<void> Function(BuildContext context, List<T> list)? onDelete;

  /// onReset is callback when reset
  Future<void> Function()? onReset;

  /// onRowsPerPageChanged is callback when rows per page changed
  Future<void> Function(BuildContext)? onRowsPerPageChanged;

  /// internalNoRefresh mean dataset has no need to refresh data, it will only use data in dataset
  bool internalNoRefresh = false;

  /// noRefresh mean dataset has no need to refresh data, it will only use data in dataset
  bool get noRefresh => internalNoRefresh;

  /// setNoRefresh set true mean dataset has no need to refresh data, it will only use data in dataset
  Future<void> setNoRefresh(BuildContext context, value) async => internalNoRefresh = value;

  /// internalNoMore mean dataset has no need to load more data, it will only use data in dataset
  bool internalNoMore = false;

  /// noMore mean dataset has no need to load more data, it will only use data in dataset
  bool get noMore => internalNoMore;

  /// setNoMore set true mean dataset has no need to load more data, it will only use data in dataset
  Future<void> setNoMore(BuildContext context, value) async => internalNoMore = value;

  /// internalRowsPerPage is current rows per page
  int internalRowsPerPage = 10;

  /// rowsPerPage is current rows per page
  int get rowsPerPage => internalRowsPerPage;

  /// setRowsPerPage set current rows per page
  @mustCallSuper
  Future<void> setRowsPerPage(BuildContext context, int value) async {
    internalRowsPerPage = value;
    await onRowsPerPageChanged?.call(context);
  }

  /// all return all rows, return null if something went wrong
  /// ```dart
  /// var rowsAll =  dataset.all;
  /// ```
  Future<List<T>> get all async => await range(0, length);

  /// length return rows length
  /// ```dart
  /// var len = dataset.length;
  /// ```
  int get length;

  /// isEmpty return rows is empty
  /// ```dart
  /// await dataset.isEmpty;
  /// ```
  bool get isEmpty => length == 0;

  /// isNotEmpty return rows is not empty
  /// ```dart
  /// await dataset.isNotEmpty;
  /// ```
  bool get isNotEmpty => !isEmpty;

  /// first return first row
  /// ```dart
  /// await dataset.first;
  /// ```
  Future<T?> get first;

  /// last return last row
  /// ```dart
  /// await dataset.last;
  /// ```
  Future<T?> get last;

  /// load dataset content
  @mustCallSuper
  Future<void> load(BuildContext context) async {}

  /// insert list of rows into dataset, it will avoid duplicate rows
  /// ```dart
  /// await dataset.insert([sample.Person()]);
  /// ```
  @mustCallSuper
  Future<void> insert(BuildContext context, List<T> list) async {
    await onInsert?.call(context, list);
  }

  /// add list of rows into dataset, it will avoid duplicate rows
  /// ```dart
  /// await dataset.add([sample.Person(name: 'hi')]);
  /// ```
  @mustCallSuper
  Future<void> add(BuildContext context, List<T> list) async {}

  /// delete list of rows from dataset
  /// ```dart
  /// await dataset.delete(list);
  /// ```
  @mustCallSuper
  Future<void> delete(BuildContext context, List<T> list) async {
    await onDelete?.call(context, list);
  }

  /// reset dataset
  /// ```dart
  /// await dataset.reset();
  /// ```
  @mustCallSuper
  Future<void> reset() async {
    await onReset?.call();
  }

  /// read return row by id
  /// ```dart
  /// final obj = await dataset.read('1');
  /// ```
  Future<T?> read(String id);

  /// range return sublist of rows, return null if something went wrong
  /// ```dart
  /// var range =  dataset.range(0, 10);
  /// ```
  Future<List<T>> range(int start, [int? end]);

  /// forEach iterate all rows
  /// ```dart
  /// await dataset.forEach();
  /// ```
  Future<void> forEach(void Function(T) callback);

  /// isIDExists return true if id is in dataset
  /// ```dart
  /// await dataset.isIDExists();
  /// ```
  bool isIDExists(String id);
}

/// removeDuplicateInTarget remove duplicate row in target list
void removeDuplicateInTarget(List source, List target) {
  for (final s in source) {
    for (final t in target) {
      if (s.id == t.id) {
        target.remove(t);
        break;
      }
    }
  }
}
