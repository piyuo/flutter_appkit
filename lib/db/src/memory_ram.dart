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
    void Function(BuildContext)? onChanged,
  }) : super(onChanged: onChanged, dataBuilder: dataBuilder);

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

  /// onOpen is called when memory need to open
  @override
  Future<void> onOpen() async {}

  /// onClose is called when memory need to close
  @override
  Future<void> onClose() async {}

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
  @mustCallSuper
  Future<void> insert(BuildContext context, List<T> list) async {
    for (T row in list) {
      _removeDuplicate(row, _rows);
    }
    _rows.insertAll(0, list);
    await super.insert(context, list);
  }

  /// add rows into ram
  /// ```dart
  /// await memory.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  @mustCallSuper
  Future<void> add(BuildContext context, List<T> list) async {
    for (T row in list) {
      _removeDuplicate(row, _rows);
    }
    _rows.addAll(list);
    await super.add(context, list);
  }

  /// remove rows from memory
  /// ```dart
  /// await memory.remove(list);
  /// ```
  @override
  @mustCallSuper
  Future<void> delete(BuildContext context, List<T> list) async {
    for (T row in list) {
      _rows.remove(row);
    }
    await super.delete(context, list);
  }

  /// clear memory
  /// ```dart
  /// await memory.clear();
  /// ```
  @override
  @mustCallSuper
  Future<void> clear(BuildContext context) async {
    _rows.clear();
    await super.clear(context);
  }

  /// setRow set row into memory and move row to first
  /// ```dart
  /// await memory.setRow(row);
  /// ```
  @override
  @mustCallSuper
  Future<void> update(BuildContext context, T row) async {
    _removeDuplicate(row, _rows);
    _rows.insert(0, row);
    await super.update(context, row);
  }

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
  Future<T?> read(String id) async {
    for (T row in _rows) {
      if (row.entityID == id) {
        return row;
      }
    }
    return null;
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
