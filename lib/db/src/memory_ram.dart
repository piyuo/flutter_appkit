import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'memory.dart';

/// MemoryRam keep memory in ram
/// ```dart
/// final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
/// await memory.open();
/// ```
class MemoryRam<T extends pb.Object> extends Memory<T> {
  /// MemoryRam keep memory in ram
  /// ```dart
  /// final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
  /// ```
  MemoryRam({
    required pb.Builder<T> dataBuilder,
  }) : super(dataBuilder: dataBuilder);

  /// _rows keep all rows in ram
  // ignore: prefer_final_fields
  List<T> _rows = [];

  /// length return rows length
  /// ```dart
  /// var len = memory.length;
  /// ```
  @override
  int get length => _rows.length;

  /// first return first row
  /// ```dart
  /// await memory.first;
  /// ```
  @override
  Future<T?> get first async => _rows.isNotEmpty ? _rows.first : null;

  /// last return last row
  /// ```dart
  /// await memory.last;
  /// ```
  @override
  Future<T?> get last async => _rows.isNotEmpty ? _rows.last : null;

  /// open memory and load content
  @override
  Future<void> open() async {}

  /// close memory
  @override
  Future<void> close() async {}

  /// reload memory content
  @override
  Future<void> reload() async {}

  /// _removeDuplicate remove duplicate row in the list
  void _removeDuplicate(T newRow, List<T> list) {
    for (T row in list) {
      if (row.entityID == newRow.entityID) {
        list.remove(row);
        break;
      }
    }
  }

  /// insert list of rows into ram
  /// ```dart
  /// await memory.insert([sample.Person()]);
  /// ```
  @override
  Future<void> insert(BuildContext context, List<T> list) async {
    for (T row in list) {
      _removeDuplicate(row, _rows);
    }
    _rows.insertAll(0, list);
  }

  /// add rows into ram
  /// ```dart
  /// await memory.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  Future<void> add(BuildContext context, List<T> list) async {
    for (T row in list) {
      _removeDuplicate(row, _rows);
    }
    _rows.addAll(list);
  }

  /// remove rows from memory
  /// ```dart
  /// await memory.remove(list);
  /// ```
  @override
  Future<void> delete(BuildContext context, List<T> list) async {
    for (T row in list) {
      _rows.remove(row);
    }
  }

  /// clear memory
  /// ```dart
  /// await memory.clear();
  /// ```
  @override
  Future<void> clear(BuildContext context) async => _rows.clear();

  /// range return sublist of rows, return null if something went wrong
  /// ```dart
  /// var range =  memory.range(0, 10);
  /// ```
  @override
  List<T> range(int start, [int? end]) => _rows.sublist(start, end);

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await memory.getRowByID('1');
  /// ```
  @override
  Future<T?> getRow(String id) async {
    for (T row in _rows) {
      if (row.entityID == id) {
        return row;
      }
    }
    return null;
  }

  /// setRow set row into memory and move row to first
  /// ```dart
  /// await memory.setRow(row);
  /// ```
  @override
  Future<void> setRow(BuildContext context, T row) async {
    _removeDuplicate(row, _rows);
    _rows.insert(0, row);
  }

  /// forEach iterate all rows
  /// ```dart
  /// await memory.forEach((row) {});
  /// ```
  @override
  Future<void> forEach(void Function(T) callback) async {
    for (T row in _rows) {
      callback(row);
    }
  }

  /// isIDExists return true if id is in memory
  /// ```dart
  /// await memory.isIDExists();
  /// ```
  @override
  bool isIDExists(String id) => _rows.any((row) => row.entityID == id);
}
