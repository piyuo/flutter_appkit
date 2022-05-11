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
  FilteredMemory(
    this._memory, {
    void Function(BuildContext)? onChanged,
  }) : super(onChanged: onChanged, dataBuilder: _memory.dataBuilder);

  /// _memory is memory need to be filter
  final Memory<T> _memory;

  List<Filter> _filters = [];

  /// _result is rows after query
  List<T> _result = [];

  /// onOpen is called when memory need to open
  @override
  Future<void> onOpen() async => await _memory.open();

  /// onClose is called when memory need to close
  @override
  Future<void> onClose() async => await _memory.close();

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
  @mustCallSuper
  Future<void> insert(BuildContext context, List<T> list) async {
    await _memory.insert(context, list);
    if (hasFilter) {
      final matched = getMatchRows(list);
      _result.insertAll(0, matched);
    }
    await super.insert(context, list);
  }

  /// add rows into ram
  /// ```dart
  /// await memory.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  @mustCallSuper
  Future<void> add(BuildContext context, List<T> list) async {
    await _memory.add(context, list);
    if (hasFilter) {
      final matched = getMatchRows(list);
      _result.addAll(matched);
    }
    await super.add(context, list);
  }

  /// add rows into ram
  /// ```dart
  /// await memory.remove(list);
  /// ```
  @override
  @mustCallSuper
  Future<void> delete(BuildContext context, List<T> list) async {
    await _memory.delete(context, list);
    _result.removeWhere((item) => list.contains(item));
    await super.delete(context, list);
  }

  /// clear memory
  /// ```dart
  /// await memory.clear();
  /// ```
  @override
  @mustCallSuper
  Future<void> clear(BuildContext context) async {
    await _memory.clear(context);
    _result = [];
    await super.clear(context);
  }

  /// setRow set row into memory and move row to first
  /// ```dart
  /// await memory.setRow(row);
  /// ```
  @override
  @mustCallSuper
  Future<void> update(BuildContext context, T row) async {
    await _memory.update(context, row);
    if (hasFilter) {
      _result.remove(row);
      if (match(row)) {
        _result.insert(0, row);
      }
    }
    await super.update(context, row);
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await memory.getRow('1');
  /// ```
  @override
  Future<T?> read(String id) async {
    if (hasFilter) {
      for (final item in _result) {
        if (item.entityID == id) {
          return item;
        }
      }
      return null;
    }
    return await _memory.read(id);
  }

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
  Future<void> forEach(void Function(T) callback) async {
    if (hasFilter) {
      _result.forEach(callback);
      return;
    }
    _memory.forEach(callback);
  }

  /// isIDExists return true if id is in memory
  /// ```dart
  /// await memory.isIDExists();
  /// ```
  @override
  bool isIDExists(String id) {
    if (hasFilter) {
      for (final item in _result) {
        if (item.entityID == id) {
          return true;
        }
      }
      return false;
    }
    return _memory.isIDExists(id);
  }
}
