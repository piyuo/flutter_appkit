import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/database/database.dart' as database;
import 'dataset.dart';

/// DatasetDatabase keep all data into a database
/// ```dart
/// final dataset = DatasetDatabase<sample.Person>(await database.open('test'), objectBuilder: () => sample.Person());
/// await dataset.load();
/// ```
class DatasetDatabase<T extends pb.Object> extends Dataset<T> {
  /// DatasetDatabase keep all data into a database
  /// ```dart
  /// final dataset = DatasetDatabase<sample.Person>(await database.open('test'), objectBuilder: () => sample.Person());
  /// await dataset.load();
  /// ```
  DatasetDatabase(
    this._database, {
    required pb.Builder<T> objectBuilder,
  }) : super(objectBuilder: objectBuilder) {
    internalNoMore = true;
  }

  /// _database is database that store data
  final database.Database _database;

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
  Future<T?> get first async => _index.isNotEmpty ? _database.getObject(_index.first, objectBuilder) : null;

  /// last return last row
  /// ```dart
  /// await dataset.last;
  /// ```
  @override
  Future<T?> get last async => _index.isNotEmpty ? _database.getObject(_index.last, objectBuilder) : null;

  /// load dataset content
  @override
  @mustCallSuper
  Future<void> load(BuildContext context) async {
    _index = await _database.getStringList(keyIndex) ?? [];
    internalRowsPerPage = await _database.getInt(keyRowsPerPage) ?? 10;
    internalNoRefresh = await _database.getBool(keyNoRefresh) ?? false;
    await super.load(context);
  }

  /// save dataset cache
  Future<void> save(BuildContext context) async {
    await _database.setStringList(keyIndex, _index);
    await _database.setInt(keyRowsPerPage, rowsPerPage);
    await _database.setBool(keyNoRefresh, noRefresh);
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

  /// insert list of rows into dataset database
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
      await _database.setObject(row.id, row);
    }
    await super.insert(context, list);
  }

  /// add list of rows into dataset database
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
      await _database.setObject(row.id, row);
    }
    await super.add(context, list);
  }

  /// delete rows from dataset
  /// ```dart
  /// await dataset.delete(list);
  /// ```
  @override
  @mustCallSuper
  Future<void> delete(BuildContext context, List<T> list) async {
    for (T row in list) {
      if (_index.contains(row.id)) {
        _index.remove(row.id);
        await _database.delete(row.id);
      }
    }
    await save(context);
    await super.delete(context, list);
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
    await _database.reset();
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
      final row = await _database.getObject(id, objectBuilder);
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
        return _database.getObject(row, objectBuilder);
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
      final obj = await _database.getObject(id, objectBuilder);
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
