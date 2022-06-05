import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'dataset.dart';

/// maxResetItem is the maximum number of items to delete in reset, rest leave to cache cleanup to avoid application busy too long.
@visibleForTesting
int get maxResetItem => kIsWeb ? 50 : 500; // web is slow, clean 50 may tak 3 sec. native is much faster

/// deleteDatasetCache delete a dataset cache
/// ```dart
/// await deleteDatasetCache('test');
/// ```
Future<void> deleteDatasetCache(String id) async {
  final all = await cache.getStringList('$id$keyIndex');
  if (all != null) {
    for (String id in all) {
      await cache.delete(id);
    }
    await cache.delete('$id$keyIndex');
    await cache.delete('$id$keyRowsPerPage');
    await cache.delete('$id$keyNoMore');
    await cache.delete('$id$keyNoRefresh');
  }
  debugPrint('[dataset_cache] $id deleted');
}

/// DatasetCache keep data in cache
/// ```dart
/// final ds = DatasetCache<sample.Person>(name: 'test', objectBuilder: () => sample.Person());
/// await ds.load();
/// ```
class DatasetCache<T extends pb.Object> extends Dataset<T> {
  /// DatasetCache keep data in cache
  /// ```dart
  /// final ds = DatasetCache<sample.Person>(name: 'test', objectBuilder: () => sample.Person());
  /// await ds.load();
  /// ```
  DatasetCache({
    required this.name,
    required pb.Builder<T> objectBuilder,
  }) : super(objectBuilder: objectBuilder);

  /// name use for database or cache id
  final String name;

  /// _index keep all id of rows
  // ignore: prefer_final_fields
  List<String> _index = [];

  /// length return rows length
  @override
  int get length => _index.length;

  /// first return first row
  /// ```dart
  /// await dataset.first;
  /// ```
  @override
  Future<T?> get first async => _index.isNotEmpty ? await cache.getObject(_index.first, objectBuilder) : null;

  /// last return last row
  /// ```dart
  /// await dataset.last;
  /// ```
  @override
  Future<T?> get last async => _index.isNotEmpty ? await cache.getObject(_index.last, objectBuilder) : null;

  /// load dataset content
  @mustCallSuper
  @override
  Future<void> load(BuildContext context) async {
    _index = await cache.getStringList('$name$keyIndex') ?? [];
    internalRowsPerPage = await cache.getInt('$name$keyRowsPerPage') ?? 10;
    internalNoRefresh = await cache.getBool('$name$keyNoRefresh') ?? false;
    internalNoMore = await cache.getBool('$name$keyNoMore') ?? false;
    await super.load(context);
  }

  /// save dataset cache
  Future<void> save(BuildContext context) async {
    await cache.setStringList('$name$keyIndex', _index);
    await cache.setInt('$name$keyRowsPerPage', internalRowsPerPage);
    await cache.setBool('$name$keyNoMore', internalNoMore);
    await cache.setBool('$name$keyNoRefresh', internalNoRefresh);
  }

  /// setRowsPerPage set current rows per page
  @override
  Future<void> setRowsPerPage(BuildContext context, value) async {
    await super.setRowsPerPage(context, value);
    await save(context);
  }

  /// setNoRefresh set true mean  no need to refresh data, it will only use data in dataset
  @override
  Future<void> setNoRefresh(BuildContext context, value) async {
    await super.setNoRefresh(context, value);
    await save(context);
  }

  /// setNoMore mean no need to load more data, it will only use data in dataset
  @override
  Future<void> setNoMore(BuildContext context, value) async {
    await super.setNoMore(context, value);
    await save(context);
  }

  /// insert list of rows into ram
  /// ```dart
  /// await dataset.insert([sample.Person()]);
  /// ```
  @override
  @mustCallSuper
  Future<void> insert(BuildContext context, List<T> list) async {
    final downloadID = list.map((row) => row.id).toList();
    _index.removeWhere((element) => downloadID.contains(element));
    _index.insertAll(0, downloadID);
    await save(context);
    for (T row in list) {
      await cache.setObject(row.id, row);
    }
    await super.insert(context, list);
  }

  /// add rows into ram
  /// ```dart
  /// await dataset.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  @mustCallSuper
  Future<void> add(BuildContext context, List<T> list) async {
    final downloadID = list.map((row) => row.id).toList();
    downloadID.removeWhere((element) => _index.contains(element));
    _index.addAll(downloadID);
    await save(context);
    for (T row in list) {
      await cache.setObject(row.id, row);
    }
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
      if (_index.contains(row.id)) {
        _index.remove(row.id);
        await cache.delete(row.id);
      }
    }
    await save(context);
    await super.delete(context, list);
  }

  /// reset dataset
  /// ```dart
  /// await dataset.reset();
  /// ```
  @override
  @mustCallSuper
  Future<void> reset() async {
    final deletedRows = _index;
    internalNoMore = false;
    internalNoRefresh = false;
    _index = [];
    await cache.delete('$name$keyIndex');
    int deleteCount = 0;
    for (String id in deletedRows) {
      await cache.delete(id);
      deleteCount++;
      if (deleteCount >= maxResetItem) {
        break;
      }
    }
    await super.reset();
  }

  /// range return sublist of rows, return null if something went wrong
  /// ```dart
  /// var range =  dataset.range(0, 10);
  /// ```
  @override
  Future<List<T>> range(int start, [int? end]) async {
    final list = _index.sublist(start, end);
    List<T> source = [];
    for (String id in list) {
      final row = await cache.getObject(id, objectBuilder);
      if (row == null) {
        // data is missing
        await reset();
        return [];
      }
      source.add(row);
    }
    return source;
  }

  /// read return object by id
  /// ```dart
  /// final obj = await dataset.read('1');
  /// ```
  @override
  Future<T?> read(String id) async {
    for (String row in _index) {
      if (row == id) {
        return await cache.getObject(row, objectBuilder);
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
    for (String id in _index) {
      final obj = await cache.getObject(id, objectBuilder);
      if (obj != null) {
        callback(obj);
      }
    }
  }

  /// isIDExists return true if id is in dataset
  /// ```dart
  /// await dataset.isIDExists();
  /// ```
  @override
  bool isIDExists(String id) => _index.contains(id);
}
