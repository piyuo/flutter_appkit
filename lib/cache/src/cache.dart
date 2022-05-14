import 'package:flutter/foundation.dart';
import 'dart:core';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/database/database.dart' as database;
import 'package:synchronized/synchronized.dart';

/// _cacheDBName is cache database name
const _cacheDBName = 'cache';

/// _cacheTimeName is cache time database name
const _cacheTimeName = 'time';

/// _cleanupMaxItem is the maximum number of items to delete in every cleanup
int _cleanupMaxItem = kIsWeb ? 50 : 500; // web is slow, clean 50 may tak 3 sec. native is much faster

/// cacheDB keep all cached data
late database.Database cacheDB;

/// timeDB keep track cached item expired time
late database.Database timeDB;

final _lock = Lock();

/// length return cached item length
int get length => cacheDB.length;

/// timeLength return timeDB length
@visibleForTesting
int get timeLength => timeDB.length;

/// setTestItem set cached item for test
@visibleForTesting
Future<void> setTestString(String timeTag, String key, dynamic value) async {
  await timeDB.setString(timeTag, key);
  await cacheDB.setString(key, value);
  await cacheDB.setString(tagKey(key), timeTag);
}

/// init cache
Future<void> init() async {
  cacheDB = await database.open(_cacheDBName);
  timeDB = await database.open(_cacheTimeName);
}

/// dispose cache
void dispose() {
  cacheDB.close();
  timeDB.close();
}

/// compact deletes 50 expired items
/// ```dart
/// await cache.compact();
/// ```
Future<void> compact() async {
  int deleteCount = 0;
  final yearBefore = DateTime.now().add(const Duration(days: -365)).millisecondsSinceEpoch;
  for (int i = 0; i < timeDB.length; i++) {
    final expirationTimeTag = await timeDB.keyAt(i);
    final expirationTime = int.parse(expirationTimeTag);
    if (expirationTime > yearBefore || deleteCount > _cleanupMaxItem) {
      break;
    }
    final key = await timeDB.getString(expirationTimeTag);
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

/// clear cache
Future<void> clear() async {
  await database.delete(_cacheDBName);
  await database.delete(_cacheTimeName);
}

/// reset reset entire cache by remove cache content (not entire db)
/// ```dart
/// await reset();
/// ```
@visibleForTesting
Future<void> reset() async {
  await _lock.synchronized(() async {
    await cacheDB.reset();
    await timeDB.reset();
  });
}

/// tagKey return key that store time tag
@visibleForTesting
String tagKey(String key) => '${key}_tag';

/// getSavedTag get saved tag
@visibleForTesting
Future<String?> getSavedTag(String key) async => await cacheDB.getString(tagKey(key));

/// setBool saves the [key] - [value] pair
/// ```dart
/// await setBool('k', true);
/// ```
Future<void> setBool(String key, bool value) async => await _set(key, (newKey) async => cacheDB.setBool(newKey, value));

/// setInt saves the [key] - [value] pair
/// ```dart
/// await setInt('k', 9);
/// ```
Future<void> setInt(String key, int value) async => await _set(key, (newKey) async => cacheDB.setInt(newKey, value));

/// setString saves the [key] - [value] pair
/// ```dart
/// await setString('k', 'a');
/// ```
Future<void> setString(String key, String value) async =>
    await _set(key, (newKey) async => cacheDB.setString(newKey, value));

/// setStringList saves the [key] - [value] pair
/// ```dart
/// await setStringList('k', ['a', 'b']);
/// ```
Future<void> setStringList(String key, List<String> value) async =>
    await _set(key, (newKey) async => cacheDB.setStringList(newKey, value));

/// setIntList saves the [key] - [value] pair
/// ```dart
/// await setIntList('k', [1, 2]);
/// ```
Future<void> setIntList(String key, List<int> value) async =>
    await _set(key, (newKey) async => cacheDB.setIntList(newKey, value));

/// setDateTime saves the [key] - [value] pair
/// ```dart
/// await setDateTime('k', date);
/// ```
Future<void> setDateTime(String key, DateTime value) async =>
    await _set(key, (newKey) async => cacheDB.setDateTime(newKey, value));

/// setObject saves the [key] - [value] pair
/// ```dart
/// await setObject('k', sample.Person(name: 'john'));
/// ```
Future<void> setObject(String key, pb.Object value) async =>
    await _set(key, (newKey) async => cacheDB.setObject(newKey, value));

/// _set saves the [key] - [value] pair
Future<void> _set(String key, Future<void> Function(String) setValueCallback) async {
  await _lock.synchronized(() async {
    debugPrint('[cache] set $key');
    String? timeTag;
    final savedTag = await getSavedTag(key);
    if (savedTag != null) {
      timeTag = savedTag;
    } else {
      timeTag = uniqueExpirationTag();
      if (timeTag.isEmpty) return;
      await timeDB.setString(timeTag, key);
      await cacheDB.setString(tagKey(key), timeTag);
    }
    await setValueCallback(key);
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
/// expect(await getBool('k'), true);
/// ```
Future<bool?> getBool(String key) async => await cacheDB.getBool(key);

/// getInt returns the value associated with the given [key]. If the key does not exist, `null` is returned.
/// ```dart
/// expect(await getInt('k'), 9);
/// ```
Future<int?> getInt(String key) async => await cacheDB.getInt(key);

/// getString returns the value associated with the given [key]. If the key does not exist, `null` is returned.
/// ```dart
/// expect(await getString('k'), 'a');
/// ```
Future<String?> getString(String key) async => await cacheDB.getString(key);

/// getStringList returns the value associated with the given [key]. If the key does not exist, `null` is returned.
/// ```dart
/// final list = await getStringList('k');
/// ```
Future<List<String>?> getStringList(String key) async => await cacheDB.getStringList(key);

/// getIntList returns the value associated with the given [key]. If the key does not exist, `null` is returned.
/// ```dart
/// final intList = await getIntList('k');
/// ```
Future<List<int>?> getIntList(String key) async => await cacheDB.getIntList(key);

/// getDateTime returns the value associated with the given [key]. If the key does not exist, `null` is returned.
/// ```dart
/// expect(await getDateTime('k'), date);
/// ```
Future<DateTime?> getDateTime(String key) async => await cacheDB.getDateTime(key);

/// getObject returns the value associated with the given [key]. If the key does not exist, `null` is returned.
/// ```dart
/// expect(await getObject<sample.Person>('k', () => sample.Person())!.name, 'john');
/// ```
Future<T?> getObject<T extends pb.Object>(String key, pb.Builder<T> builder) async =>
    await cacheDB.getObject(key, builder);

/// deletes the given [key] from the box , If it does not exist, nothing happens.
Future<void> delete(String key) async {
  await _lock.synchronized(() async {
    debugPrint('[cache] delete $key');
    key = key;
    final savedTag = await getSavedTag(key);
    if (savedTag != null) {
      await timeDB.delete(savedTag);
    }
    await cacheDB.delete(key);
    await cacheDB.delete(tagKey(key));
  });
}
