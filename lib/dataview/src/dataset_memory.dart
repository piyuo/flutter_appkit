import 'package:flutter/foundation.dart';
import 'package:libcli/net/net.dart' as net;
import 'package:libcli/cache/cache.dart' as cache;
import 'dataset.dart';

/// maxResetItem is the maximum number of items to delete in reset, rest leave to cache cleanup to avoid application busy too long.
@visibleForTesting
int get maxResetItem => kIsWeb ? 50 : 500; // web is slow, clean 50 may tak 3 sec. native is much faster

/// deleteDatasetCache delete a dataset cache
/// ```dart
/// await deleteDatasetCache('test');
/// ```
Future<void> deleteDatasetCache(cache.MemoryProvider memoryProvider, String id) async {
  final all = await memoryProvider.get('$id$keyIndex');
  if (all != null) {
    for (String id in all) {
      await memoryProvider.delete(id);
    }
    await memoryProvider.delete('$id$keyIndex');
    await memoryProvider.delete('$id$keyRowsPerPage');
    await memoryProvider.delete('$id$keyNoMore');
    await memoryProvider.delete('$id$keyNoRefresh');
  }
}

/// DatasetMemory keep data in memory
class DatasetMemory<T extends net.Object> extends Dataset<T> {
  /// DatasetCache keep data in cache
  /// ```dart
  /// final ds = DatasetMemory<sample.Person>(memoryProvider:memoryProvider,name: 'test', objectBuilder: () => sample.Person());
  /// await ds.load();
  /// ```
  DatasetMemory({
    required this.memoryProvider,
    required this.name,
    required super.objectBuilder,
  });

  /// memoryProvider use for database or cache id
  final cache.MemoryProvider memoryProvider;

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
  Future<T?> get first async => _index.isNotEmpty ? await memoryProvider.getObject(_index.first, objectBuilder) : null;

  /// last return last row
  /// ```dart
  /// await dataset.last;
  /// ```
  @override
  Future<T?> get last async => _index.isNotEmpty ? await memoryProvider.getObject(_index.last, objectBuilder) : null;

  /// load dataset content
  @mustCallSuper
  @override
  Future<void> load() async {
    _index = await memoryProvider.get('$name$keyIndex') ?? [];
    internalRowsPerPage = await memoryProvider.get('$name$keyRowsPerPage') ?? 10;
    internalNoRefresh = await memoryProvider.get('$name$keyNoRefresh') ?? false;
    internalNoMore = await memoryProvider.get('$name$keyNoMore') ?? false;
    await super.load();
  }

  /// save dataset cache
  Future<void> save() async {
    await memoryProvider.put('$name$keyIndex', _index);
    await memoryProvider.put('$name$keyRowsPerPage', internalRowsPerPage);
    await memoryProvider.put('$name$keyNoMore', internalNoMore);
    await memoryProvider.put('$name$keyNoRefresh', internalNoRefresh);
  }

  /// setRowsPerPage set current rows per page
  @override
  Future<void> setRowsPerPage(value) async {
    await super.setRowsPerPage(value);
    await save();
  }

  /// setNoRefresh set true mean  no need to refresh data, it will only use data in dataset
  @override
  Future<void> setNoRefresh(value) async {
    await super.setNoRefresh(value);
    await save();
  }

  /// setNoMore mean no need to load more data, it will only use data in dataset
  @override
  Future<void> setNoMore(value) async {
    await super.setNoMore(value);
    await save();
  }

  /// insert list of rows into ram
  /// ```dart
  /// await dataset.insert([sample.Person()]);
  /// ```
  @override
  @mustCallSuper
  Future<void> insert(List<T> list) async {
    final downloadID = list.map((row) => row.id).toList();
    _index.removeWhere((element) => downloadID.contains(element));
    _index.insertAll(0, downloadID);
    await save();
    for (T row in list) {
      await memoryProvider.putObject(row.id, row);
    }
  }

  /// add rows into ram
  /// ```dart
  /// await dataset.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  @mustCallSuper
  Future<void> add(List<T> list) async {
    final downloadID = list.map((row) => row.id).toList();
    downloadID.removeWhere((element) => _index.contains(element));
    _index.addAll(downloadID);
    await save();
    for (T row in list) {
      await memoryProvider.putObject(row.id, row);
    }
    await super.add(list);
  }

  /// remove rows from dataset
  /// ```dart
  /// await dataset.remove(list);
  /// ```
  @override
  @mustCallSuper
  Future<void> delete(List<String> list) async {
    for (String id in list) {
      if (_index.contains(id)) {
        _index.remove(id);
        await memoryProvider.delete(id);
      }
    }
    await save();
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
    await memoryProvider.delete('$name$keyIndex');
    int deleteCount = 0;
    for (String id in deletedRows) {
      await memoryProvider.delete(id);
      deleteCount++;
      if (deleteCount >= maxResetItem) {
        break;
      }
    }
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
      final row = await memoryProvider.getObject(id, objectBuilder);
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
        return await memoryProvider.getObject(row, objectBuilder);
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
      final obj = await memoryProvider.getObject(id, objectBuilder);
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
