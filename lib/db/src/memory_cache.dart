import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'memory.dart';
import 'cache.dart';

/// maxResetItem is the maximum number of items to delete in reset, rest leave to cache cleanup to avoid application busy too long.
@visibleForTesting
int get maxResetItem => kIsWeb ? 50 : 500; // web is slow, clean 50 may tak 3 sec. native is much faster

/// deleteMemoryCache delete a memory cache
/// ```dart
/// await deleteMemoryCache('test');
/// ```
Future<void> deleteMemoryCache(Cache cache, String id) async {
  final all = cache.getStringList('$id$keyIndex');
  if (all != null) {
    for (String id in all) {
      await cache.delete(id);
    }
    await cache.delete('$id$keyIndex');
    await cache.delete('$id$keyRowsPerPage');
    await cache.delete('$id$keyNoMore');
    await cache.delete('$id$keyNoRefresh');
  }
  debugPrint('[memory_cache] $id deleted');
}

/// MemoryCache keep memory in cache
/// ```dart
/// final memory = MemoryCache<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
/// await memory.open();
/// ```
class MemoryCache<T extends pb.Object> extends Memory<T> {
  /// MemoryCache keep memory in cache
  /// ```dart
  /// final memory = MemoryCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
  /// await memory.open();
  /// ```
  MemoryCache(
    this._cache, {
    required this.name,
    required pb.Builder<T> dataBuilder,
    VoidCallback? onChanged,
  }) : super(onChanged: onChanged, dataBuilder: dataBuilder);

  /// name use for database or cache id
  final String name;

  /// _cache is the cache store memory cache
  final Cache _cache;

  /// _index keep all id of rows
  // ignore: prefer_final_fields
  List<String> _index = [];

  /// length return rows length
  @override
  int get length => _index.length;

  /// first return first row
  /// ```dart
  /// await memory.first;
  /// ```
  @override
  Future<T?> get first async => _index.isNotEmpty ? _cache.getObject(_index.first, dataBuilder) : null;

  /// last return last row
  /// ```dart
  /// await memory.last;
  /// ```
  @override
  Future<T?> get last async => _index.isNotEmpty ? _cache.getObject(_index.last, dataBuilder) : null;

  /// open memory cache and load content
  /// ```dart
  /// await memory.open();
  /// ```
  @override
  Future<void> open() async {
    await reload();
  }

  /// close memory
  @override
  Future<void> close() async {}

  /// reload memory content
  /// ```dart
  /// await memory.reload();
  /// ```
  @override
  Future<void> reload() async {
    _index = _cache.getStringList('$name$keyIndex') ?? [];
    internalRowsPerPage = _cache.getInt('$name$keyRowsPerPage') ?? 10;
    internalNoRefresh = _cache.getBool('$name$keyNoRefresh') ?? false;
    internalNoMore = _cache.getBool('$name$keyNoMore') ?? false;
  }

  /// save memory cache
  Future<void> save(BuildContext context) async {
    await _cache.setStringList('$name$keyIndex', _index);
    await _cache.setInt('$name$keyRowsPerPage', internalRowsPerPage);
    await _cache.setBool('$name$keyNoMore', internalNoMore);
    await _cache.setBool('$name$keyNoRefresh', internalNoRefresh);
  }

  /// setRowsPerPage set current rows per page
  @override
  Future<void> setRowsPerPage(BuildContext context, value) async {
    await super.setRowsPerPage(context, value);
    await save(context);
  }

  /// setNoRefresh set true mean dataset has no need to refresh data, it will only use data in memory
  @override
  Future<void> setNoRefresh(BuildContext context, value) async {
    await super.setNoRefresh(context, value);
    await save(context);
  }

  /// setNoMore mean dataset has no need to load more data, it will only use data in memory
  @override
  Future<void> setNoMore(BuildContext context, value) async {
    await super.setNoMore(context, value);
    await save(context);
  }

  /// insert list of rows into ram
  /// ```dart
  /// await memory.insert([sample.Person()]);
  /// ```
  @override
  @mustCallSuper
  Future<void> insert(BuildContext context, List<T> list) async {
    final downloadID = list.map((row) => row.entityID).toList();
    _index.removeWhere((element) => downloadID.contains(element));
    _index.insertAll(0, downloadID);
    await save(context);
    for (T row in list) {
      await _cache.setObject(row.entityID, row);
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
    final downloadID = list.map((row) => row.entityID).toList();
    downloadID.removeWhere((element) => _index.contains(element));
    _index.addAll(downloadID);
    await save(context);
    for (T row in list) {
      await _cache.setObject(row.entityID, row);
    }
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
      if (_index.contains(row.entityID)) {
        _index.remove(row.entityID);
        await _cache.delete(row.entityID);
      }
    }
    await save(context);
    await super.delete(context, list);
  }

  /// clear memory
  /// ```dart
  /// await memory.clear();
  /// ```
  @override
  @mustCallSuper
  Future<void> clear(BuildContext context) async {
    final deletedRows = _index;
    internalNoMore = false;
    internalNoRefresh = false;
    _index = [];
    await _cache.delete('$name$keyIndex');
    int deleteCount = 0;
    for (String id in deletedRows) {
      await _cache.delete(id);
      deleteCount++;
      if (deleteCount >= maxResetItem) {
        break;
      }
    }
    await super.clear(context);
  }

  /// update set row into memory and move row to first
  /// ```dart
  /// await memory.update(row);
  /// ```
  @override
  Future<void> update(BuildContext context, T row) async {
    _index.removeWhere((id) => row.entityID == id);
    _index.insert(0, row.entityID);
    await save(context);
    await _cache.setObject(row.entityID, row);
    await super.update(context, row);
  }

  /// range return sublist of rows, return null if something went wrong
  /// ```dart
  /// var range =  memory.range(0, 10);
  /// ```
  @override
  List<T> range(int start, [int? end]) {
    final list = _index.sublist(start, end);
    List<T> source = [];
    for (String id in list) {
      final row = _cache.getObject(id, dataBuilder);
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
  /// final obj = await memory.read('1');
  /// ```
  @override
  Future<T?> read(String id) async {
    for (String row in _index) {
      if (row == id) {
        return _cache.getObject(row, dataBuilder);
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
    for (String id in _index) {
      final obj = _cache.getObject(id, dataBuilder);
      if (obj != null) {
        callback(obj);
      }
    }
  }

  /// isIDExists return true if id is in memory
  /// ```dart
  /// await memory.isIDExists();
  /// ```
  @override
  bool isIDExists(String id) => _index.contains(id);
}
