import 'package:hive/hive.dart';
import 'package:libcli/pb/pb.dart' as pb;

/// Database represent indexedDB
class Database {
  Database();

  /// _box is hive box
  late Box _box;

  /// use a db, create new one if database not exists
  Future<void> open(String name, {bool cleanBeforeUse = false}) async {
    _box = await Hive.openBox(name);
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
  bool contains(String key) => _box.containsKey(key);

  /// setInt save int to database
  Future<void> setInt(String key, int value) => _box.put(key, value);

  /// setBool save bool to database
  Future<void> setBool(String key, bool value) => _box.put(key, value);

  /// setIntList save int list to database
  Future<void> setIntList(String key, List<int> value) => _box.put(key, value);

  /// setString save string to database
  Future<void> setString(String key, String value) => _box.put(key, value);

  /// setStringList save string list to database
  Future<void> setStringList(String key, List<String> value) => _box.put(key, value);

  /// setDateTime save datetime to database
  Future<void> setDateTime(String key, DateTime value) => _box.put(key, value);

  /// setObject save object to database
  Future<void> setObject(String key, pb.Object value) async {
    _box.put(key, value.writeToBuffer());
  }

  /// getBool return the value associated with the given [key]
  bool? getBool(String key) => _box.get(key);

  /// getInt return the value associated with the given [key]
  int? getInt(String key) => _box.get(key);

  /// getIntList return the value associated with the given [key]
  List<int>? getIntList(String key) => _box.get(key);

  /// getString return the value associated with the given [key]
  String? getString(String key) => _box.get(key);

  /// getStringList return the value associated with the given [key]
  List<String>? getStringList(String key) => _box.get(key);

  /// getDateTime return the value associated with the given [key]
  DateTime? getDateTime(String key) => _box.get(key);

  /// getObject return the value associated with the given [key]
  T? getObject<T extends pb.Object>(String key, pb.Builder<T> builder) {
    final value = _box.get(key);
    if (value == null) {
      return null;
    }
    return builder()..mergeFromBuffer(value);
  }

  /// delete the given [key] from the box ,if it does not exist, nothing happens.
  Future<void> delete(String key) => _box.delete(key);

  Future<void> reset() async {
    for (var key in _box.keys) {
      await _box.delete(key);
    }
  }
}
