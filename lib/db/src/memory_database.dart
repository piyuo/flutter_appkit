import 'package:libcli/pb/pb.dart' as pb;
import 'database.dart';
import 'memory.dart';
import 'db.dart';

/// deleteMemoryDatabase delete memory database
/// ```dart
/// await deleteMemoryDatabase('test');
/// ```
Future<void> deleteMemoryDatabase(String id) async => deleteDatabase(id);

/// MemoryDatabase keep memory into a separate database
/// ```dart
/// final memory = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
/// await memory.open();
/// ```
class MemoryDatabase<T extends pb.Object> extends Memory<T> {
  /// MemoryDatabase keep memory into a separate database
  /// ```dart
  /// final memory = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
  /// await memory.open();
  /// ```
  MemoryDatabase({
    required this.id,
    required pb.Builder<T> dataBuilder,
  }) : super(dataBuilder: dataBuilder) {
    internalNoMore = true;
  }

  /// id is the unique id of this dataset, it is used to cache data
  final String id;

  /// _index keep all id of rows
  // ignore: prefer_final_fields
  List<String> _index = [];

  /// _database is database that store dataset
  late Database _database;

  /// length return rows length
  @override
  int get length => _index.length;

  /// first return first row
  /// ```dart
  /// await memory.first;
  /// ```
  @override
  Future<T?> get first async => _index.isNotEmpty ? _database.getObject(_index.first, dataBuilder) : null;

  /// last return last row
  /// ```dart
  /// await memory.last;
  /// ```
  @override
  Future<T?> get last async => _index.isNotEmpty ? _database.getObject(_index.last, dataBuilder) : null;

  /// open memory database and load content
  /// ```dart
  /// await memory.open();
  /// ```
  @override
  Future<void> open() async {
    _database = await openDatabase(id);
    await reload();
  }

  /// reload memory content
  /// ```dart
  /// await memory.reload();
  /// ```
  @override
  Future<void> reload() async {
    _index = _database.getStringList(keyIndex) ?? [];
    internalRowsPerPage = _database.getInt(keyRowsPerPage) ?? 10;
    internalNoRefresh = _database.getBool(keyNoRefresh) ?? false;
  }

  /// close memory database
  /// ```dart
  /// await memory.close();
  /// ```
  @override
  Future<void> close() async {
    _database.close();
  }

  /// _save save memory cache
  Future<void> _save() async {
    await _database.setStringList(keyIndex, _index);
    await _database.setInt(keyRowsPerPage, rowsPerPage);
    await _database.setBool(keyNoRefresh, noRefresh);
  }

  /// setRowsPerPage set current rows per page
  @override
  Future<void> setRowsPerPage(value) async {
    await super.setRowsPerPage(value);
    await _save();
  }

  /// setNoRefresh set true mean dataset has no need to refresh data, it will only use data in memory
  @override
  Future<void> setNoRefresh(value) async {
    await super.setNoRefresh(value);
    await _save();
  }

  /// insert list of rows into memory database
  /// ```dart
  /// await memory.insert([sample.Person()]);
  /// ```
  @override
  Future<void> insert(List<T> list) async {
    final downloadID = list.map((row) => row.entityID).toList();
    _index.removeWhere((element) => downloadID.contains(element));
    _index.insertAll(0, downloadID);
    await _save();
    for (T row in list) {
      await _database.setObject(row.entityID, row);
    }
  }

  /// add list of rows into memory database
  /// ```dart
  /// await memory.add([sample.Person(name: 'hi')]);
  /// ```
  @override
  Future<void> add(List<T> list) async {
    final downloadID = list.map((row) => row.entityID).toList();
    downloadID.removeWhere((element) => _index.contains(element));
    _index.addAll(downloadID);
    await _save();
    for (T row in list) {
      await _database.setObject(row.entityID, row);
    }
  }

  /// delete rows from memory
  /// ```dart
  /// await memory.delete(list);
  /// ```
  @override
  Future<void> delete(List<T> list) async {
    for (T row in list) {
      if (_index.contains(row.entityID)) {
        _index.remove(row.entityID);
        await _database.delete(row.entityID);
      }
    }
    await _save();
  }

  /// clear memory database
  /// ```dart
  /// await memory.clear();
  /// ```
  @override
  Future<void> clear() async {
    _index = [];
    await _database.close();
    await deleteMemoryDatabase(id);
    _database = await openDatabase(id);
    internalNoRefresh = false;
  }

  /// sublist return sublist of rows, return null if something went wrong
  /// ```dart
  /// var subRows = await memory.subRows(0, 10);
  /// ```
  @override
  Future<List<T>?> range(int start, [int? end]) async {
    final list = _index.sublist(start, end);
    List<T> source = [];
    for (String id in list) {
      final row = _database.getObject(id, dataBuilder);
      if (row == null) {
        // data is missing
        _index = [];
        internalNoMore = false;
        await _save();
        return null;
      }
      source.add(row);
    }
    return source;
  }

  /// setRow set row into memory and move row to first
  /// ```dart
  /// await memory.setRow(row);
  /// ```
  @override
  Future<void> setRow(T row) async {
    _index.removeWhere((id) => row.entityID == id);
    _index.insert(0, row.entityID);
    await _save();
    await _database.setObject(row.entityID, row);
  }

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await memory.getRowByID('1');
  /// ```
  @override
  Future<T?> getRow(String id) async {
    for (String row in _index) {
      if (row == id) {
        return _database.getObject(row, dataBuilder);
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
      final obj = _database.getObject(id, dataBuilder);
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
