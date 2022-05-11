import 'package:flutter/foundation.dart';
import 'dart:core';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:synchronized/synchronized.dart';
import 'db.dart';
import 'database.dart';

/// cleanupWhenSet is when to cleanup on every 50th set
const int cleanupWhenSet = 50;

/// cleanupMaxItem is the maximum number of items to delete in every cleanup
int get cleanupMaxItem => kIsWeb ? 50 : 500; // web is slow, clean 50 may tak 3 sec. native is much faster

/// createCache create new cache
Future<Cache> createCache(String cacheName, String timeName) async {
  final cache = await openDatabase(cacheName);
  final time = await openDatabase(timeName);
  return Cache(cacheDB: cache, timeDB: time);
}

/// deleteCache delete cache
Future<void> deleteCache(String cacheName, String timeName) async {
  await deleteDatabase(cacheName);
  await deleteDatabase(timeName);
}

/// Cache is a object cache
/// ```dart
/// final cache = await openCache('cache_db', 'time_db');
/// try {
///   await cache.setString('k', 'hello');
/// } finally {
///   await deleteCache('cache_db', 'time_db');
/// }
/// ```
class Cache {
  /// Cache is a object cache
  /// ```dart
  /// final cache = await openCache('cache_db', 'time_db');
  /// try {
  ///   await cache.setString('k', 'hello');
  /// } finally {
  ///   await deleteCache('cache_db', 'time_db');
  /// }
  /// ```
  Cache({
    required this.cacheDB,
    required this.timeDB,
  });

  final _lock = Lock();

  /// _setCount count how many set, if > 10 then cleanup cache
  int _setCount = 0;

  /// cacheDB keep all cached data
  Database cacheDB;

  /// timeDB keep track cached item expired time
  Database timeDB;

  /// resetCache reset entire cache by remove cache content (not entire db)
  /// ```dart
  /// resetCache();
  /// ```
  @visibleForTesting
  Future<void> reset() async {
    await _lock.synchronized(() async {
      await cacheDB.reset();
      await timeDB.reset();
      _setCount = 0;
    });
  }

  /// close cache
  void close() {
    cacheDB.close();
    timeDB.close();
  }

  /// tagKey return key that store time tag
  @visibleForTesting
  String tagKey(String key) => '${key}_tag';

  /// getSavedTag get saved tag
  @visibleForTesting
  String? getSavedTag(String key) => cacheDB.getString(tagKey(key));

  /// setBool saves the [key] - [value] pair
  /// ```dart
  /// await setBool('k', true);
  /// ```
  Future<void> setBool(String key, bool value) => _set(key, (newKey) async => cacheDB.setBool(newKey, value));

  /// setInt saves the [key] - [value] pair
  /// ```dart
  /// await setInt('k', 9);
  /// ```
  Future<void> setInt(String key, int value) => _set(key, (newKey) async => cacheDB.setInt(newKey, value));

  /// setString saves the [key] - [value] pair
  /// ```dart
  /// await setString('k', 'a');
  /// ```
  Future<void> setString(String key, String value) => _set(key, (newKey) async => cacheDB.setString(newKey, value));

  /// setStringList saves the [key] - [value] pair
  /// ```dart
  /// await setStringList('k', ['a', 'b']);
  /// ```
  Future<void> setStringList(String key, List<String> value) =>
      _set(key, (newKey) async => cacheDB.setStringList(newKey, value));

  /// setIntList saves the [key] - [value] pair
  /// ```dart
  /// await setIntList('k', [1, 2]);
  /// ```
  Future<void> setIntList(String key, List<int> value) =>
      _set(key, (newKey) async => cacheDB.setIntList(newKey, value));

  /// setDateTime saves the [key] - [value] pair
  /// ```dart
  /// await setDateTime('k', date);
  /// ```
  Future<void> setDateTime(String key, DateTime value) =>
      _set(key, (newKey) async => cacheDB.setDateTime(newKey, value));

  /// setObject saves the [key] - [value] pair
  /// ```dart
  /// await setObject('k', sample.Person(name: 'john'));
  /// ```
  Future<void> setObject(String key, pb.Object value) => _set(key, (newKey) async => cacheDB.setObject(newKey, value));

  /// _set saves the [key] - [value] pair
  Future<void> _set(String key, Future<void> Function(String) setValueCallback) async {
    await _lock.synchronized(() async {
      debugPrint('[cache] set $key');
      String? timeTag;
      final savedTag = getSavedTag(key);
      if (savedTag != null) {
        timeTag = savedTag;
      } else {
        timeTag = uniqueExpirationTag();
        if (timeTag.isEmpty) return;
        await timeDB.setString(timeTag, key);
        await cacheDB.setString(tagKey(key), timeTag);
      }

      await setValueCallback(key);
      _setCount++;
      if (_setCount > cleanupWhenSet) {
        _setCount = 0;
        if (!kReleaseMode) {
          await cleanup();
          return;
        }
        cleanup(); // don't wait cleanup
      }
    });
  }

  /// uniqueExpirationTag return unique expiration time tag use in timeDB
  @visibleForTesting
  String uniqueExpirationTag() {
    int tag = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 100; i++) {
      final tagStr = tag.toString();
      if (!timeDB.contains(tagStr)) {
        return tagStr;
      }
      tag++;
    }
    return '';
  }

  /// contains return true if key is in cache
  /// ```dart
  /// expect(cache.contains('k'), false);
  /// ```
  bool contains(dynamic key) => cacheDB.contains(key);

  /// getBool returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  /// ```dart
  /// expect(getBool('k'), true);
  /// ```
  bool? getBool(String key) => cacheDB.getBool(key);

  /// getInt returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  /// ```dart
  /// expect(getInt('k'), 9);
  /// ```
  int? getInt(String key) => cacheDB.getInt(key);

  /// getString returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  /// ```dart
  /// expect(getString('k'), 'a');
  /// ```
  String? getString(String key) => cacheDB.getString(key);

  /// getStringList returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  /// ```dart
  /// final list = getStringList('k');
  /// ```
  List<String>? getStringList(String key) => cacheDB.getStringList(key);

  /// getIntList returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  /// ```dart
  /// final intList = getIntList('k');
  /// ```
  List<int>? getIntList(String key) => cacheDB.getIntList(key);

  /// getDateTime returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  /// ```dart
  /// expect(getDateTime('k'), date);
  /// ```
  DateTime? getDateTime(String key) => cacheDB.getDateTime(key);

  /// getObject returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  /// ```dart
  /// expect(getObject<sample.Person>('k', () => sample.Person())!.name, 'john');
  /// ```
  T? getObject<T extends pb.Object>(String key, pb.Builder<T> builder) {
    return cacheDB.getObject(key, builder);
  }

  /// deletes the given [key] from the box , If it does not exist, nothing happens.
  Future<void> delete(String key) async {
    await _lock.synchronized(() async {
      debugPrint('[cache] delete $key');
      key = key;
      final savedTag = getSavedTag(key);
      if (savedTag != null) {
        await timeDB.delete(savedTag);
      }
      await cacheDB.delete(key);
      await cacheDB.delete(tagKey(key));
    });
  }

  /// cleanup deletes 10 expired items
  /// ```dart
  /// await cache.cleanup();
  /// ```
  Future<void> cleanup() async {
    int deleteCount = 0;
    final yearBefore = DateTime.now().add(const Duration(days: -365)).millisecondsSinceEpoch;
    for (int i = 0; i < timeDB.length; i++) {
      final expirationTimeTag = await timeDB.keyAt(i);
      final expirationTime = int.parse(expirationTimeTag);
      if (expirationTime > yearBefore || deleteCount > cleanupMaxItem) {
        break;
      }
      final key = timeDB.getString(expirationTimeTag);
      if (key != null) {
        await cacheDB.delete(key);
        await cacheDB.delete(tagKey(key));
      }
      await timeDB.delete(expirationTimeTag);
      deleteCount++;
    }
    if (deleteCount > 0) {
      debugPrint('[cache] cleanup $deleteCount items');
    }
  }

  /// length return cached item length
  int get length => cacheDB.length;

  /// timeLength return timeDB length
  @visibleForTesting
  int get timeLength => timeDB.length;

  /// _setCount return current set count
  @visibleForTesting
  int get setCount => _setCount;

  /// setTestItem set cached item for test
  @visibleForTesting
  Future<void> setTestString(String timeTag, String key, dynamic value) async {
    await timeDB.setString(timeTag, key);
    await cacheDB.setString(key, value);
    await cacheDB.setString(tagKey(key), timeTag);
  }
}
