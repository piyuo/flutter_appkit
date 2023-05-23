import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'dataset.dart';

/// DatasetDb keep all data into a database
/// ```dart
/// final dataset = DatasetDb<sample.Person>(await database.open('test'), objectBuilder: () => sample.Person());
/// await dataset.load();
/// ```
class DatasetDb<T extends pb.Object> extends Dataset<T> {
  /// DatasetDatabase keep all data into a database
  /// ```dart
  /// final dataset = DatasetDb<sample.Person>(await database.open('test'), objectBuilder: () => sample.Person());
  /// await dataset.load();
  /// ```
  DatasetDb({
    required this.indexedDbProvider,
    required pb.Builder<T> objectBuilder,
  }) : super(objectBuilder: objectBuilder) {
    internalNoMore = true;
  }

  /// indexedDbProvider is IndexedDB database that store data
  final cache.IndexedDbProvider indexedDbProvider;

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
  Future<T?> get first async => _index.isNotEmpty ? indexedDbProvider.getObject(_index.first, objectBuilder) : null;

  /// last return last row
  /// ```dart
  /// await dataset.last;
  /// ```
  @override
  Future<T?> get last async => _index.isNotEmpty ? indexedDbProvider.getObject(_index.last, objectBuilder) : null;

  /// load dataset content
  @override
  @mustCallSuper
  Future<void> load() async {
    _index = await indexedDbProvider.get(keyIndex) ?? [];
    internalRowsPerPage = await indexedDbProvider.get(keyRowsPerPage) ?? 10;
    internalNoRefresh = await indexedDbProvider.get(keyNoRefresh) ?? false;
    await super.load();
  }

  /// save dataset cache
  Future<void> save() async {
    await indexedDbProvider.put(keyIndex, _index);
    await indexedDbProvider.put(keyRowsPerPage, rowsPerPage);
    await indexedDbProvider.put(keyNoRefresh, noRefresh);
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

  /// insert list of rows into dataset database
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
      await indexedDbProvider.putObject(row.id, row);
    }
  }

  /// add list of rows into dataset database
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
      await indexedDbProvider.putObject(row.id, row);
    }
    await super.add(list);
  }

  /// delete rows from dataset
  /// ```dart
  /// await dataset.delete(list);
  /// ```
  @override
  @mustCallSuper
  Future<void> delete(List<String> list) async {
    for (String id in list) {
      if (_index.contains(id)) {
        _index.remove(id);
        await indexedDbProvider.delete(id);
      }
    }
    await save();
  }

  /// reset dataset database
  /// ```dart
  /// await dataset.reset();
  /// ```
  @override
  @mustCallSuper
  Future<void> reset() async {
    _index = [];
    internalNoRefresh = false;
    await indexedDbProvider.reset();
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
      final row = await indexedDbProvider.getObject(id, objectBuilder);
      if (row == null) {
        // data is missing, reset data
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
        return indexedDbProvider.getObject(row, objectBuilder);
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
      final obj = await indexedDbProvider.getObject(id, objectBuilder);
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
