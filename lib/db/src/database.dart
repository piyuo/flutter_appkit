import 'package:hive/hive.dart';
import 'package:libcli/pb/pb.dart' as pb;

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
  final Box _box;

  /// close database, If you don't need a box again, you should close it. All cached keys and values of the box will be dropped from memory and the box file is closed after all active read and write operations finished.
  Future<void> close() async {
    //Hive is an append-only data store. When you change or delete a value, the change is written to the end of the box file. Sooner or later, the box file uses more disk space than it should. Hive may automatically "compact" your box at any time to close the "holes" in the file.
    //It may benefit the start time of your app if you induce compaction manually before you close a box.
    await _box.compact();
    await _box.close();
  }

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

  /// setInt save int to database
  /// ```dart
  /// await database.setInt('key', 1);
  /// ```
  Future<void> setInt(String key, int value) => _box.put(key, value);

  /// setBool save bool to database
  /// ```dart
  /// await database.setBool('k', false);
  /// ```
  Future<void> setBool(String key, bool value) => _box.put(key, value);

  /// setIntList save int list to database
  /// ```dart
  /// await database.setIntList('l', list);
  /// ```
  Future<void> setIntList(String key, List<int> value) => _box.put(key, value);

  /// setString save string to database
  /// ```dart
  /// await database.setBool('k', false);
  /// ```
  Future<void> setString(String key, String value) => _box.put(key, value);

  /// setStringList save string list to database
  /// ```dart
  /// await database.setStringList('l', list);
  /// ```
  Future<void> setStringList(String key, List<String> value) => _box.put(key, value);

  /// setDateTime save datetime to database
  /// ```dart
  /// await database.setDateTime('k', now);
  /// ```
  Future<void> setDateTime(String key, DateTime value) => _box.put(key, value);

  /// setObject save object to database
  /// ```dart
  /// await database.setObject('k', person);
  /// ```
  Future<void> setObject(String key, pb.Object value) async {
    _box.put(key, value.writeToBuffer());
  }

  /// getBool return the value associated with the given [key]
  /// ```dart
  /// final value = database.getBool('k');
  /// ```
  bool? getBool(String key) => _box.get(key);

  /// getInt return the value associated with the given [key]
  /// ```dart
  ///  final value = database.getInt('k');
  /// ```
  int? getInt(String key) => _box.get(key);

  /// getIntList return the value associated with the given [key]
  /// ```dart
  /// var list2 = database.getIntList('l');
  /// ```
  List<int>? getIntList(String key) => _box.get(key);

  /// getString return the value associated with the given [key]
  /// ```dart
  /// final value = database.getString('k');
  /// ```
  String? getString(String key) => _box.get(key);

  /// getStringList return the value associated with the given [key]
  /// ```dart
  /// var list2 = database.getStringList('l');
  /// ```
  List<String>? getStringList(String key) => _box.get(key);

  /// getDateTime return the value associated with the given [key]
  /// ```dart
  /// final value = database.getDateTime('k');
  /// ```
  DateTime? getDateTime(String key) => _box.get(key);

  /// getObject return the value associated with the given [key]
  /// ```dart
  /// final value = database.getObject<sample.Person>('k', () => sample.Person());
  /// ```
  T? getObject<T extends pb.Object>(String key, pb.Builder<T> builder) {
    final value = _box.get(key);
    if (value == null) {
      return null;
    }
    return builder()..mergeFromBuffer(value);
  }

  /// delete the given [key] from the box ,if it does not exist, nothing happens.
  /// ```dart
  /// await database.delete('k');
  /// ```
  Future<void> delete(String key) => _box.delete(key);

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
