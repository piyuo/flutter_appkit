import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'memory.dart';
import 'filter.dart';

/// Memory keep rows for later use
/// ```dart
/// final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
/// final filter = FilteredMemory(memory);
/// ```
class FilteredMemory<T extends pb.Object> extends Memory<T> {
  /// Memory keep rows for later use
  /// ```dart
  /// final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
  /// final filter = FilteredMemory(memory);
  /// ```
  FilteredMemory(this._memory) : super(dataBuilder: _memory.dataBuilder);

  /// _memory is memory need to be filter
  final Memory<T> _memory;

  List<Filter> _filters = [];

  /// _result is rows after query
  List<T> _result = [];

  /// open memory and load content
  @override
  Future<void> open() async => await _memory.open();

  /// close memory
  @override
  @mustCallSuper
  Future<void> close() async => await _memory.close();

  /// reload memory content
  @override
  Future<void> reload() async => await _memory.reload();

  /// setFilters set filter to memory
  /// ```dart
  /// await memory.setFilters(filters);
  /// ```
  Future<void> setFilters(List<Filter<T>> queries) async {
    if (queries.isEmpty) {
      _result = [];
      _filters = [];
      return;
    }

    _filters = queries;
    await _runFilter();
  }

  /// getMatchRows return list of rows that match filters
  List<T> getMatchRows(List<T> rows) {
    var list = <T>[];
    for (final row in rows) {
      if (match(row)) {
        list.add(row);
      }
    }
    return list;
  }

  /// match return rows that match filter
  bool match(T row) {
    for (var query in _filters) {
      if (!query.isMatch(row)) {
        return false;
      }
    }
    return true;
  }

  /// _runFilter put filtered rows to _result
  Future<void> _runFilter() async {
    _result = [];
    await _memory.forEach(
      (row) async {
        if (match(row)) {
          _result.add(row);
        }
      },
    );
  }

  /// hasFilter return true if has filters defined
  /// ```dart
  /// await memory.hasFilter;
  /// ```
  bool get hasFilter => _filters.isNotEmpty;

  /// length return rows length
  /// ```dart
  /// var len = memory.length;
  /// ```
  @override
  int get length => hasFilter ? _result.length : _memory.length;

  /// first return first row
  /// ```dart
  /// await memory.first;
  /// ```
  @override
  Future<T?> get first async => hasFilter
      ? _result.isEmpty
          ? null
          : _result.first
      : await _memory.first;

  /// last return last row
  /// ```dart
  /// await memory.last;
  /// ```
  @override
  Future<T?> get last async => hasFilter
      ? _result.isEmpty
          ? null
          : _result.last
      : await _memory.last;

  /// insert list of rows into ram
  /// ```dart
  /// await memory.insert([sample.Person()]);
  /// ```
  @override
  Future<void> insert(BuildContext context, List<T> list) async {
    await _memory.insert(context, list);
    if (hasFilter) {
      final matched = getMatchRows(list);
      _result.insertAll(0, matched);
    }
  }

  /// add rows into ram
  /// ```dart
  /// await memory.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  Future<void> add(BuildContext context, List<T> list) async {
    await _memory.add(context, list);
    if (hasFilter) {
      final matched = getMatchRows(list);
      _result.addAll(matched);
    }
  }

  /// add rows into ram
  /// ```dart
  /// await memory.remove(list);
  /// ```
  @override
  Future<void> delete(BuildContext context, List<T> list) async {
    await _memory.delete(context, list);
    await _runFilter();
  }

  /// clear memory
  /// ```dart
  /// await memory.clear();
  /// ```
  @override
  Future<void> clear(BuildContext context) async {
    await _memory.clear(context);
    _result = [];
  }

  /// setRow set row into memory and move row to first
  /// ```dart
  /// await memory.setRow(row);
  /// ```
  @override
  Future<void> setRow(BuildContext context, T row) async {
    await _memory.setRow(context, row);
    await _runFilter();
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await memory.getRowByID('1');
  /// ```
  @override
  Future<T?> getRow(String id) async => await _memory.getRow(id);

  /// range return sublist of rows, return null if something went wrong
  /// ```dart
  /// var range =  memory.range(0, 10);
  /// ```
  @override
  List<T> range(int start, [int? end]) {
    if (hasFilter) {
      return _result.sublist(start, end);
    }
    return _memory.range(start, end);
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
