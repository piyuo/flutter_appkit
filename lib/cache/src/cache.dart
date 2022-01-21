import 'package:flutter/foundation.dart';
import 'dart:core';
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:synchronized/synchronized.dart';

/// cleanupWhenSet is when to cleanup on every 50th set
const int cleanupWhenSet = 50;

/// cleanupMaxItem is the maximum number of items to delete in every cleanup
int get cleanupMaxItem => kIsWeb ? 50 : 500; // web is slow, clean 50 may tak 3 sec. native is much faster

final _lock = Lock();

/// cacheDB keep all cached data
db.Database? _cacheDB;

/// timeDB keep track cached item expired time
db.Database? _timeDB;

/// _setCount count how many set, if > 10 then cleanup cache
int _setCount = 0;

/// init cache env
Future<void> init() async {
  _timeDB ??= await db.open('time');
  _cacheDB ??= await db.open('cache');
}

/// initForTest init test database
Future<void> initForTest() async {
  await cleanupTest();
  _cacheDB ??= await db.open('test_cache');
  _timeDB ??= await db.open('test_time');
}

/// cleanupTest cleanup test database
Future<void> cleanupTest() async {
  // ignore: invalid_use_of_visible_for_testing_member
  await db.deleteTestDb('test_cache');
  // ignore: invalid_use_of_visible_for_testing_member
  await db.deleteTestDb('test_time');
}

/// reset entire cache by remove cache file
@visibleForTesting
Future<void> reset() async {
  await _lock.synchronized(() async {
    await _cacheDB?.reset();
    await _timeDB?.reset();
    _setCount = 0;
  });
}

/// tagKey return key that store time tag
@visibleForTesting
String tagKey(String key) => '${key}_tag';

/// getSavedTag get saved tag
@visibleForTesting
String? getSavedTag(String key) => _cacheDB!.getString(tagKey(key));

/// setBool saves the [key] - [value] pair
Future<void> setBool(String key, bool value) => _set(key, (newKey) async => _cacheDB!.setBool(newKey, value));

/// setInt saves the [key] - [value] pair
Future<void> setInt(String key, int value) => _set(key, (newKey) async => _cacheDB!.setInt(newKey, value));

/// setString saves the [key] - [value] pair
Future<void> setString(String key, String value) => _set(key, (newKey) async => _cacheDB!.setString(newKey, value));

/// setStringList saves the [key] - [value] pair
Future<void> setStringList(String key, List<String> value) =>
    _set(key, (newKey) async => _cacheDB!.setStringList(newKey, value));

/// setDateTime saves the [key] - [value] pair
Future<void> setDateTime(String key, DateTime value) =>
    _set(key, (newKey) async => _cacheDB!.setDateTime(newKey, value));

/// setObject saves the [key] - [value] pair
Future<void> setObject(String key, pb.Object value) => _set(key, (newKey) async => _cacheDB!.setObject(newKey, value));

/// _set saves the [key] - [value] pair
Future<void> _set(String key, Future<void> Function(String) setValueCallback) async {
  await _lock.synchronized(() async {
    assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
    debugPrint('[cache] set $key');
    String? timeTag;
    final savedTag = getSavedTag(key);
    if (savedTag != null) {
      timeTag = savedTag;
    } else {
      timeTag = uniqueExpirationTag();
      if (timeTag.isEmpty) return;
      await _timeDB!.setString(timeTag, key);
      await _cacheDB!.setString(tagKey(key), timeTag);
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
    if (!_timeDB!.contains(tagStr)) {
      return tagStr;
    }
    tag++;
  }
  return '';
}

/// contains return true if key is in cache
bool contains(dynamic key) => _cacheDB!.contains(key);

/// getBool returns the value associated with the given [key]. If the key does not exist, `null` is returned.
bool? getBool(String key) {
  assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
  return _cacheDB!.getBool(key);
}

/// getInt returns the value associated with the given [key]. If the key does not exist, `null` is returned.
int? getInt(String key) {
  assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
  return _cacheDB!.getInt(key);
}

/// getString returns the value associated with the given [key]. If the key does not exist, `null` is returned.
String? getString(String key) {
  assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
  return _cacheDB!.getString(key);
}

/// getStringList returns the value associated with the given [key]. If the key does not exist, `null` is returned.
List<String>? getStringList(String key) {
  assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
  return _cacheDB!.getStringList(key);
}

/// getIntList returns the value associated with the given [key]. If the key does not exist, `null` is returned.
List<int>? getIntList(String key) {
  assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
  return _cacheDB!.getIntList(key);
}

/// getDateTime returns the value associated with the given [key]. If the key does not exist, `null` is returned.
DateTime? getDateTime(String key) {
  assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
  return _cacheDB!.getDateTime(key);
}

/// getObject returns the value associated with the given [key]. If the key does not exist, `null` is returned.
T? getObject<T extends pb.Object>(String key, pb.Builder<T> builder) {
  assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
  return _cacheDB!.getObject(key, builder);
}

/// deletes the given [key] from the box , If it does not exist, nothing happens.
Future<void> delete(String key) async {
  await _lock.synchronized(() async {
    assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
    debugPrint('[cache] delete $key');
    key = key;
    final savedTag = getSavedTag(key);
    if (savedTag != null) {
      await _timeDB!.delete(savedTag);
    }
    await _cacheDB!.delete(key);
    await _cacheDB!.delete(tagKey(key));
  });
}

/// cleanup deletes 10 expired items
Future<void> cleanup() async {
  assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
  int deleteCount = 0;
  final yearBefore = DateTime.now().add(const Duration(days: -365)).millisecondsSinceEpoch;
  for (int i = 0; i < _timeDB!.length; i++) {
    final expirationTimeTag = await _timeDB!.keyAt(i);
    final expirationTime = int.parse(expirationTimeTag);
    if (expirationTime > yearBefore || deleteCount > cleanupMaxItem) {
      break;
    }
    final key = _timeDB!.getString(expirationTimeTag);
    if (key != null) {
      await _cacheDB!.delete(key);
      await _cacheDB!.delete(tagKey(key));
    }
    await _timeDB!.delete(expirationTimeTag);
    deleteCount++;
  }
  if (deleteCount > 0) {
    debugPrint('[cache] cleanup $deleteCount items');
  }
}

/// length return cached item length
int get length => _cacheDB!.length;

/// timeLength return timeDB length
@visibleForTesting
int get timeLength => _timeDB!.length;

/// _setCount return current set count
@visibleForTesting
int get setCount => _setCount;

/// setTestItem set cached item for test
@visibleForTesting
Future<void> setTestString(String timeTag, String key, dynamic value) async {
  assert(_cacheDB != null && _timeDB != null, 'please call await cache.init() first');
  await _timeDB!.setString(timeTag, key);
  await _cacheDB!.setString(key, value);
  await _cacheDB!.setString(tagKey(key), timeTag);
}
