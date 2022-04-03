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
  Future<void> insert(List<T> list) async {
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
  Future<void> add(List<T> list) async {
    for (T row in list) {
      _removeDuplicate(row, _rows);
    }
    _rows.addAll(list);
  }

  /// clear memory
  /// ```dart
  /// await memory.clear();
  /// ```
  @override
  Future<void> clear() async => _rows.clear();

  /// subRows return sublist of rows
  /// ```dart
  /// var subRows = await memory.subRows(0, 10);
  /// ```
  @override
  Future<List<T>?> subRows(int start, [int? end]) async => _rows.sublist(start, end);

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await memory.getRowByID('1');
  /// ```
  @override
  Future<T?> getRowByID(String id) async {
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
  Future<void> setRow(T row) async {
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
