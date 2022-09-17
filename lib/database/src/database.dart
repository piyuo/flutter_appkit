import 'package:hive/hive.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'base.dart';

/// Database represent indexedDB database
/// ```dart
/// final database = await open('database_name');
/// ```
class Database {
  /// Database represent indexedDB database
  /// ```dart
  /// final database = await openDatabase('database_name');
  /// ```
  Database(this._box);

  /// _box is hive box
  final LazyBox _box;

  /// close database, If you don't need a box again, you should close it. All cached keys and values of the box will be dropped from memory and the box file is closed after all active read and write operations finished.
  Future<void> close() async => await closeBox(_box);

  /// keys is all the keys in the box, The keys are sorted alphabetically in ascending order.
  Iterable<String> get keys => _box.keys as Iterable<String>;

  /// keyAt return the n-th key in the box.
  Future<String> keyAt(int index) async => _box.keyAt(index);

  /// length is the number of entries in the box.
  int get length => _box.length;

  /// isEmpty returns `true` if there are no entries in this box.
  bool get isEmpty => _box.isEmpty;

  /// isNotEmpty returns true if there is at least one entries in this box.
  bool get isNotEmpty => _box.isNotEmpty;

  /// contains checks whether the box contains the [key].
  /// ```dart
  /// expect(database.contains('a'), false);
  /// ```
  bool contains(String key) => _box.containsKey(key);

  /// setInt save map to database
  /// ```dart
  /// await database.setMap('key', {'a': 1}));
  /// ```
  Future<void> setMap(String key, Map<String, dynamic> value) async => await _box.put(key, value);

  /// setInt save int to database
  /// ```dart
  /// await database.setInt('key', 1);
  /// ```
  Future<void> setInt(String key, int value) async => await _box.put(key, value);

  /// setBool save bool to database
  /// ```dart
  /// await database.setBool('k', false);
  /// ```
  Future<void> setBool(String key, bool value) async => await _box.put(key, value);

  /// setIntList save int list to database
  /// ```dart
  /// await database.setIntList('l', list);
  /// ```
  Future<void> setIntList(String key, List<int> value) async => await _box.put(key, value);

  /// setString save string to database
  /// ```dart
  /// await database.setBool('k', false);
  /// ```
  Future<void> setString(String key, String value) async => await _box.put(key, value);

  /// setStringList save string list to database
  /// ```dart
  /// await database.setStringList('l', list);
  /// ```
  Future<void> setStringList(String key, List<String> value) async => await _box.put(key, value);

  /// setDateTime save datetime to database
  /// ```dart
  /// await database.setDateTime('k', now);
  /// ```
  Future<void> setDateTime(String key, DateTime value) async => await _box.put(key, value);

  /// setObject save object to database
  /// ```dart
  /// await database.setObject('k', person);
  /// ```
  Future<void> setObject(String key, pb.Object value) async => await _box.put(key, value.writeToBuffer());

  /// getBool return the value associated with the given [key]
  /// ```dart
  /// final value = database.getBool('k');
  /// ```
  Future<bool?> getBool(String key) async => await _box.get(key);

  /// getMap return the value associated with the given [key]
  /// ```dart
  ///  final value = database.getMap('k');
  /// ```
  Future<Map<dynamic, dynamic>?> getMap(String key) async => await _box.get(key);

  /// getInt return the value associated with the given [key]
  /// ```dart
  ///  final value = database.getInt('k');
  /// ```
  Future<int?> getInt(String key) async => await _box.get(key);

  /// getIntList return the value associated with the given [key]
  /// ```dart
  /// var list2 = database.getIntList('l');
  /// ```
  Future<List<int>?> getIntList(String key) async => await _box.get(key);

  /// getString return the value associated with the given [key]
  /// ```dart
  /// final value = database.getString('k');
  /// ```
  Future<String?> getString(String key) async => await _box.get(key);

  /// getStringList return the value associated with the given [key]
  /// ```dart
  /// var list2 = database.getStringList('l');
  /// ```
  Future<List<String>?> getStringList(String key) async {
    final list = await _box.get(key);
    if (list is List<dynamic>) {
      return list.map((item) => item.toString()).toList();
    }
    return null;
  }

  /// getDateTime return the value associated with the given [key]
  /// ```dart
  /// final value = database.getDateTime('k');
  /// ```
  Future<DateTime?> getDateTime(String key) async => await _box.get(key);

  /// getObject return the value associated with the given [key]
  /// ```dart
  /// final value = database.getObject<sample.Person>('k', () => sample.Person());
  /// ```
  Future<T?> getObject<T extends pb.Object>(String key, pb.Builder<T> builder) async {
    final value = await _box.get(key);
    if (value == null) {
      return null;
    }
    return builder()..mergeFromBuffer(value);
  }

  /// delete the given [key] from the box ,if it does not exist, nothing happens.
  /// ```dart
  /// await database.delete('k');
  /// ```
  Future<void> delete(String key) async => await _box.delete(key);

  /// reset clear everything in box
  /// ```dart
  /// await database.reset();
  /// ```
  Future<void> reset() async {
    for (var key in _box.keys) {
      await _box.delete(key);
    }
  }
}
