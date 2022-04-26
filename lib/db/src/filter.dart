import 'package:libcli/pb/pb.dart' as pb;
import 'memory.dart';
import 'query.dart';

class Filter<T extends pb.Object> extends Memory<T> {
  Filter(this._memory) : super(dataBuilder: _memory.dataBuilder);

  final Memory<T> _memory;

  List<Query> _queries = [];

  /// _result is rows after query
  List<String> _result = [];

  /// setFilters set filter to memory
  /// ```dart
  /// await memory.setFilters(filters);
  /// ```
  Future<void> setQueries(List<Query<T>> queries) async {
    if (queries.isEmpty) {
      _result = [];
      _queries = [];
      return;
    }

    _queries = queries;
    await _query();
  }

  Future<void> _query() async {
    _result = [];
    await _memory.forEach(
      (row) async {
        var isMatch = true;
        for (var query in _queries) {
          if (!query.isMatch(row)) {
            isMatch = false;
            break;
          }
        }
        if (isMatch) {
          _result.add(row.entityID);
        }
      },
    );
  }

  /// hasQueries return true if has queries
  /// ```dart
  /// await memory.hasQueries;
  /// ```
  bool get hasQueries => _queries.isNotEmpty;

  /// length return rows length
  /// ```dart
  /// var len = memory.length;
  /// ```
  @override
  int get length => hasQueries ? _result.length : _memory.length;

  /// first return first row
  /// ```dart
  /// await memory.first;
  /// ```
  @override
  Future<T?> get first async => hasQueries
      ? _result.isEmpty
          ? null
          : await getRowByID(_result.first)
      : await _memory.first;

  /// last return last row
  /// ```dart
  /// await memory.last;
  /// ```
  @override
  Future<T?> get last async => hasQueries
      ? _result.isEmpty
          ? null
          : await getRowByID(_result.last)
      : await _memory.last;

  /// insert list of rows into ram
  /// ```dart
  /// await memory.insert([sample.Person()]);
  /// ```
  @override
  Future<void> insert(List<T> list) async {
    await _memory.insert(list);
    await _query();
  }

  /// add rows into ram
  /// ```dart
  /// await memory.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  Future<void> add(List<T> list) async {
    await _memory.add(list);
    await _query();
  }

  /// add rows into ram
  /// ```dart
  /// await memory.remove(list);
  /// ```
  @override
  Future<void> remove(List<T> list) async {
    await _memory.remove(list);
    await _query();
  }

  /// clear memory
  /// ```dart
  /// await memory.clear();
  /// ```
  @override
  Future<void> clear() async {
    await _memory.clear();
    _result = [];
  }

  /// subRows return sublist of rows
  /// ```dart
  /// var subRows = await memory.subRows(0, 10);
  /// ```
  @override
  Future<List<T>?> subRows(int start, [int? end]) async {
    if (hasQueries) {
      List<T> list = [];
      final idList = _result.sublist(start, end);
      for (String id in idList) {
        final row = await getRowByID(id);
        if (row != null) {
          list.add(row);
        }
      }
      return list;
    }
    return await _memory.subRows(start, end);
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await memory.getRowByID('1');
  /// ```
  @override
  Future<T?> getRowByID(String id) async => await _memory.getRowByID(id);

  /// setRow set row into memory and move row to first
  /// ```dart
  /// await memory.setRow(row);
  /// ```
  @override
  Future<void> setRow(T row) async {
    await _memory.setRow(row);
    await _query();
  }

  /// forEach iterate all rows
  /// ```dart
  /// await memory.forEach((row) {});
  /// ```
  @override
  Future<void> forEach(void Function(T) callback) async => _memory.forEach(callback);

  /// isIDExists return true if id is in memory
  /// ```dart
  /// await memory.isIDExists();
  /// ```
  @override
  bool isIDExists(String id) => _memory.isIDExists(id);
}
