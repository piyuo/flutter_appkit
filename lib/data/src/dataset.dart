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
/// final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
/// await memory.open();
/// ```
abstract class Dataset<T extends pb.Object> {
  /// Dataset keep rows for later use
  /// ```dart
  /// final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
  /// await memory.open();
  /// ```
  Dataset({
    required this.dataBuilder,
    this.onChanged,
  });

  /// isOpened is true when memory is open
  bool isOpened = false;

  /// dataBuilder build data
  /// ```dart
  /// dataBuilder: () => sample.Person()
  /// ```
  final pb.Builder<T> dataBuilder;

  /// onChanged called when memory changed like insert, delete, update
  Future<void> Function(BuildContext)? onChanged;

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
  Future<void> setRowsPerPage(BuildContext context, value) async => internalRowsPerPage = value;

  /// all return all rows, return null if something went wrong
  /// ```dart
  /// var rowsAll =  memory.all;
  /// ```
  Future<List<T>> get all async => await range(0, length);

  /// length return rows length
  /// ```dart
  /// var len = memory.length;
  /// ```
  int get length;

  /// isEmpty return rows is empty
  /// ```dart
  /// await memory.isEmpty;
  /// ```
  bool get isEmpty => length == 0;

  /// isNotEmpty return rows is not empty
  /// ```dart
  /// await memory.isNotEmpty;
  /// ```
  bool get isNotEmpty => !isEmpty;

  /// first return first row
  /// ```dart
  /// await memory.first;
  /// ```
  Future<T?> get first;

  /// last return last row
  /// ```dart
  /// await memory.last;
  /// ```
  Future<T?> get last;

  /// onOpen is called when memory need to open
  Future<void> onOpen();

  /// onClose is called when memory need to close
  Future<void> onClose();

  /// open memory and load content
  Future<void> open() async {
    if (isOpened) {
      return;
    }
    await onOpen();
    isOpened = true;
  }

  /// close memory
  Future<void> close() async {
    if (!isOpened) {
      return;
    }
    await onClose();
    isOpened = false;
  }

  /// reload memory content
  Future<void> reload();

  /// insert list of rows into memory, it will avoid duplicate rows
  /// ```dart
  /// await memory.insert([sample.Person()]);
  /// ```
  @mustCallSuper
  Future<void> insert(BuildContext context, List<T> list) async {
    await onChanged?.call(context);
  }

  /// add list of rows into memory, it will avoid duplicate rows
  /// ```dart
  /// await memory.add([sample.Person(name: 'hi')]);
  /// ```
  @mustCallSuper
  Future<void> add(BuildContext context, List<T> list) async {
    await onChanged?.call(context);
  }

  /// delete list of rows from memory
  /// ```dart
  /// await memory.delete(list);
  /// ```
  @mustCallSuper
  Future<void> delete(BuildContext context, List<T> list) async {
    await onChanged?.call(context);
  }

  /// reset memory
  /// ```dart
  /// await memory.reset();
  /// ```
  @mustCallSuper
  Future<void> reset(BuildContext context) async {
    await onChanged?.call(context);
  }

  /// update set a single row into memory and move row to first
  /// ```dart
  /// await memory.update(row);
  /// ```
  @mustCallSuper
  Future<void> update(BuildContext context, T row) async {
    await onChanged?.call(context);
  }

  /// read return row by id
  /// ```dart
  /// final obj = await memory.read('1');
  /// ```
  Future<T?> read(String id);

  /// range return sublist of rows, return null if something went wrong
  /// ```dart
  /// var range =  memory.range(0, 10);
  /// ```
  Future<List<T>> range(int start, [int? end]);

  /// forEach iterate all rows
  /// ```dart
  /// await memory.forEach();
  /// ```
  Future<void> forEach(void Function(T) callback);

  /// isIDExists return true if id is in memory
  /// ```dart
  /// await memory.isIDExists();
  /// ```
  bool isIDExists(String id);
}
