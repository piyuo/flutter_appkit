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
/// final ds = DatasetCache<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
/// await ds.open();
/// ```
class DatasetCache<T extends pb.Object> extends Dataset<T> {
  /// DatasetCache keep data in cache
  /// ```dart
  /// final ds = DatasetCache<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
  /// await ds.open();
  /// ```
  DatasetCache({
    required this.name,
    required pb.Builder<T> dataBuilder,
    Future<void> Function(BuildContext)? onChanged,
  }) : super(onChanged: onChanged, dataBuilder: dataBuilder);

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
  Future<T?> get first async => _index.isNotEmpty ? await cache.getObject(_index.first, dataBuilder) : null;

  /// last return last row
  /// ```dart
  /// await dataset.last;
  /// ```
  @override
  Future<T?> get last async => _index.isNotEmpty ? await cache.getObject(_index.last, dataBuilder) : null;

  /// load dataset content
  @override
  Future<void> load() async {
    _index = await cache.getStringList('$name$keyIndex') ?? [];
    internalRowsPerPage = await cache.getInt('$name$keyRowsPerPage') ?? 10;
    internalNoRefresh = await cache.getBool('$name$keyNoRefresh') ?? false;
    internalNoMore = await cache.getBool('$name$keyNoMore') ?? false;
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
    final downloadID = list.map((row) => row.entityID).toList();
    _index.removeWhere((element) => downloadID.contains(element));
    _index.insertAll(0, downloadID);
    await save(context);
    for (T row in list) {
      await cache.setObject(row.entityID, row);
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
    final downloadID = list.map((row) => row.entityID).toList();
    downloadID.removeWhere((element) => _index.contains(element));
    _index.addAll(downloadID);
    await save(context);
    for (T row in list) {
      await cache.setObject(row.entityID, row);
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
      if (_index.contains(row.entityID)) {
        _index.remove(row.entityID);
        await cache.delete(row.entityID);
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
  Future<void> reset(BuildContext context) async {
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
    await super.reset(context);
  }

  /// update set row into dataset and move row to first
  /// ```dart
  /// await dataset.update(row);
  /// ```
  @override
  Future<void> update(BuildContext context, T row) async {
    _index.removeWhere((id) => row.entityID == id);
    _index.insert(0, row.entityID);
    await save(context);
    await cache.setObject(row.entityID, row);
    await super.update(context, row);
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
      final row = await cache.getObject(id, dataBuilder);
      if (row == null) {
        // data is missing
        _index = [];
        internalNoMore = false;
        internalNoRefresh = false;
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
        return await cache.getObject(row, dataBuilder);
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
      final obj = await cache.getObject(id, dataBuilder);
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
