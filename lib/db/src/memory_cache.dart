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
  /// final memory = MemoryCache<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
  /// await memory.open();
  /// ```
  MemoryCache(
    this._cache, {
    required this.id,
    required pb.Builder<T> dataBuilder,
  }) : super(dataBuilder: dataBuilder);

  /// id is the unique id of this dataset, it is used to cache data
  final String id;

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

  /// open memory cache
  /// ```dart
  /// await memory.open();
  /// ```
  @override
  Future<void> open() async {
    _index = _cache.getStringList('$id$keyIndex') ?? [];
    rowsPerPage = _cache.getInt('$id$keyRowsPerPage') ?? 10;
    noRefresh = _cache.getBool('$id$keyNoRefresh') ?? false;
    noMore = _cache.getBool('$id$keyNoMore') ?? false;
  }

  /// save memory cache
  /// ```dart
  /// await memory.save();
  /// ```
  @override
  Future<void> save() async {
    await _cache.setStringList('$id$keyIndex', _index);
    await _cache.setInt('$id$keyRowsPerPage', rowsPerPage);
    await _cache.setBool('$id$keyNoMore', noMore);
    await _cache.setBool('$id$keyNoRefresh', noRefresh);
  }

  /// insert list of rows into ram
  /// ```dart
  /// await memory.insert([sample.Person()]);
  /// ```
  @override
  Future<void> insert(List<T> list) async {
    final downloadID = list.map((row) => row.entityID).toList();
    _index.removeWhere((element) => downloadID.contains(element));
    _index.insertAll(0, downloadID);
    await save();
    for (T row in list) {
      await _cache.setObject(row.entityID, row);
    }
  }

  /// add rows into ram
  /// ```dart
  /// await memory.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  Future<void> add(List<T> list) async {
    final downloadID = list.map((row) => row.entityID).toList();
    downloadID.removeWhere((element) => _index.contains(element));
    _index.addAll(downloadID);
    await save();
    for (T row in list) {
      await _cache.setObject(row.entityID, row);
    }
  }

  /// remove rows from memory
  /// ```dart
  /// await memory.remove(list);
  /// ```
  @override
  Future<void> remove(List<T> list) async {
    for (T row in list) {
      if (_index.contains(row.entityID)) {
        _index.remove(row.entityID);
        await _cache.delete(row.entityID);
      }
    }
  }

  /// clear memory
  /// ```dart
  /// await memory.clear();
  /// ```
  @override
  Future<void> clear() async {
    final deletedRows = _index;
    noMore = false;
    noRefresh = false;
    _index = [];
    await _cache.delete('$id$keyIndex');
    int deleteCount = 0;
    for (String id in deletedRows) {
      await _cache.delete(id);
      deleteCount++;
      if (deleteCount >= maxResetItem) {
        break;
      }
    }
    debugPrint('[memory_cache] clear');
  }

  /// sublist return sublist of rows, return null if something went wrong
  /// ```dart
  /// var subRows = await memory.subRows(0, 10);
  /// ```
  @override
  Future<List<T>?> subRows(int start, [int? end]) async {
    final list = _index.sublist(start, end);
    List<T> source = [];
    for (String id in list) {
      final row = _cache.getObject(id, dataBuilder);
      if (row == null) {
        // data is missing
        _index = [];
        noMore = false;
        noRefresh = false;
        await save();
        return null;
      }
      source.add(row);
    }
    return source;
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await memory.getRowByID('1');
  /// ```
  @override
  Future<T?> getRowByID(String id) async {
    for (String row in _index) {
      if (row == id) {
        return _cache.getObject(row, dataBuilder);
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
    _index.removeWhere((id) => row.entityID == id);
    _index.insert(0, row.entityID);
    await save();
    await _cache.setObject(row.entityID, row);
    onRowSet?.call(row);
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
