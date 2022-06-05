import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';

/// DatasetRam keep data in ram
/// ```dart
/// final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
/// ```
class DatasetRam<T extends pb.Object> extends Dataset<T> {
  /// DatasetRam keep data in ram
  /// ```dart
  /// final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
  /// ```
  DatasetRam({
    required pb.Builder<T> objectBuilder,
  }) : super(objectBuilder: objectBuilder);

  /// _rows keep all rows in ram
  // ignore: prefer_final_fields
  List<T> _rows = [];

  /// length return rows length
  /// ```dart
  /// var len = dataset.length;
  /// ```
  @override
  int get length => _rows.length;

  /// first return first row
  /// ```dart
  /// await dataset.first;
  /// ```
  @override
  Future<T?> get first async => _rows.isNotEmpty ? _rows.first : null;

  /// last return last row
  /// ```dart
  /// await dataset.last;
  /// ```
  @override
  Future<T?> get last async => _rows.isNotEmpty ? _rows.last : null;

  /// insert list of rows into ram
  /// ```dart
  /// await dataset.insert([sample.Person()]);
  /// ```
  @override
  @mustCallSuper
  Future<void> insert(BuildContext context, List<T> list) async {
    removeDuplicateInTarget(list, _rows);
    _rows.insertAll(0, list);
    await super.insert(context, list);
  }

  /// add rows into ram
  /// ```dart
  /// await dataset.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  @mustCallSuper
  Future<void> add(BuildContext context, List<T> list) async {
    removeDuplicateInTarget(list, _rows);
    _rows.addAll(list);
    await super.add(context, list);
  }

  /// remove rows from dataset
  /// ```dart
  /// await dataset.remove(list);
  /// ```
  @override
  @mustCallSuper
  Future<void> delete(BuildContext context, List<T> list) async {
    for (T row in list) {
      _rows.remove(row);
    }
    await super.delete(context, list);
  }

  /// reset dataset
  /// ```dart
  /// await dataset.reset();
  /// ```
  @override
  @mustCallSuper
  Future<void> reset() async {
    _rows.clear();
    await super.reset();
  }

  /// range return sublist of rows, return null if something went wrong
  /// ```dart
  /// var range =  dataset.range(0, 10);
  /// ```
  @override
  Future<List<T>> range(int start, [int? end]) async => _rows.sublist(start, end);

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await dataset.getRowByID('1');
  /// ```
  @override
  Future<T?> read(String id) async {
    for (T row in _rows) {
      if (row.id == id) {
        return row;
      }
    }
    return null;
  }

  /// forEach iterate all rows
  /// ```dart
  /// await dataset.forEach((row) {});
  /// ```
  @override
  Future<void> forEach(void Function(T) callback) async {
    for (T row in _rows) {
      callback(row);
    }
  }

  /// isIDExists return true if id is in dataset
  /// ```dart
  /// await dataset.isIDExists();
  /// ```
  @override
  bool isIDExists(String id) => _rows.any((row) => row.id == id);
}
