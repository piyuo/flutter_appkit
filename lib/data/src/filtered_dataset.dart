import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';
import 'filter.dart';

/// FilteredDataset filter data from Dataset
/// ```dart
/// final dsRam = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
/// final filter = FilteredDataset(dsRam);
/// ```
class FilteredDataset<T extends pb.Object> extends Dataset<T> {
  /// FilteredDataset filter data from Dataset
  /// ```dart
  /// final dsRam = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
  /// final filter = FilteredDataset(dsRam);
  /// ```
  FilteredDataset(this._dataset) : super(dataBuilder: _dataset.dataBuilder);

  /// _dataset is dataset need to be filter
  final Dataset<T> _dataset;

  List<Filter> _filters = [];

  /// _result is rows after query
  List<T> _result = [];

  /// load dataset content
  @override
  Future<void> load() async => await _dataset.load();

  /// setFilters set filter to dataset
  /// ```dart
  /// await dataset.setFilters(filters);
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
    await _dataset.forEach(
      (row) async {
        if (match(row)) {
          _result.add(row);
        }
      },
    );
  }

  /// hasFilter return true if has filters defined
  /// ```dart
  /// await dataset.hasFilter;
  /// ```
  bool get hasFilter => _filters.isNotEmpty;

  /// length return rows length
  /// ```dart
  /// var len = dataset.length;
  /// ```
  @override
  int get length => hasFilter ? _result.length : _dataset.length;

  /// first return first row
  /// ```dart
  /// await dataset.first;
  /// ```
  @override
  Future<T?> get first async => hasFilter
      ? _result.isEmpty
          ? null
          : _result.first
      : await _dataset.first;

  /// last return last row
  /// ```dart
  /// await dataset.last;
  /// ```
  @override
  Future<T?> get last async => hasFilter
      ? _result.isEmpty
          ? null
          : _result.last
      : await _dataset.last;

  /// insert list of rows into ram
  /// ```dart
  /// await dataset.insert([sample.Person()]);
  /// ```
  @override
  @mustCallSuper
  Future<void> insert(BuildContext context, List<T> list) async {
    await _dataset.insert(context, list);
    if (hasFilter) {
      final matched = getMatchRows(list);
      _result.insertAll(0, matched);
    }
  }

  /// add rows into ram
  /// ```dart
  /// await dataset.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  @mustCallSuper
  Future<void> add(BuildContext context, List<T> list) async {
    await _dataset.add(context, list);
    if (hasFilter) {
      final matched = getMatchRows(list);
      _result.addAll(matched);
    }
  }

  /// add rows into ram
  /// ```dart
  /// await dataset.remove(list);
  /// ```
  @override
  @mustCallSuper
  Future<void> delete(BuildContext context, List<T> list) async {
    await _dataset.delete(context, list);
    _result.removeWhere((item) => list.contains(item));
  }

  /// clear dataset
  /// ```dart
  /// await dataset.clear();
  /// ```
  @override
  @mustCallSuper
  Future<void> reset() async {
    await _dataset.reset();
    _result = [];
  }

  /// setRow set row into dataset and move row to first
  /// ```dart
  /// await dataset.setRow(row);
  /// ```
  @override
  @mustCallSuper
  Future<void> update(BuildContext context, T row) async {
    await _dataset.update(context, row);
    if (hasFilter) {
      _result.remove(row);
      if (match(row)) {
        _result.insert(0, row);
      }
    }
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await dataset.getRow('1');
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
    return await _dataset.read(id);
  }

  /// range return sublist of rows, return null if something went wrong
  /// ```dart
  /// var range =  dataset.range(0, 10);
  /// ```
  @override
  Future<List<T>> range(int start, [int? end]) async {
    if (hasFilter) {
      return _result.sublist(start, end);
    }
    return _dataset.range(start, end);
  }

  /// forEach iterate all rows
  /// ```dart
  /// await dataset.forEach((row) {});
  /// ```
  @override
  Future<void> forEach(void Function(T) callback) async {
    if (hasFilter) {
      _result.forEach(callback);
      return;
    }
    _dataset.forEach(callback);
  }

  /// isIDExists return true if id is in dataset
  /// ```dart
  /// await dataset.isIDExists();
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
    return _dataset.isIDExists(id);
  }
}
