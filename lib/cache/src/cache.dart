import 'package:flutter/foundation.dart';
import 'dart:core';
import 'package:libcli/db/db.dart' as db;

/// cleanupWhenSet is when to cleanup on every 10th set
const int cleanupWhenSet = 5;

/// cleanupMaxItem is the maximum number of items to delete in every cleanup
const int cleanupMaxItem = 20;

/// cacheDB keep all cached data
late db.DB _cacheDB;

/// timeDB keep track cached item expired time
late db.DB _timeDB;

/// _setCount count how many set, if > 10 then cleanup cache
int _setCount = 0;

/// init cache env
Future<void> init() async {
  _timeDB = await db.use('time');
  _cacheDB = await db.use('cache');
}

/// tagKey return key that store time tag
@visibleForTesting
String tagKey(String key) => '${key}_tag';

/// getSavedTag get saved tag
@visibleForTesting
Future<String?> getSavedTag(String key) async => await _cacheDB.get(tagKey(key));

/// namespaceKey return key in namespace
@visibleForTesting
String namespaceKey(String? namespace, String key) => namespace != null ? '${namespace}_$key' : key;

/// set saves the [key] - [value] pair
Future<void> set(dynamic key, dynamic value, {String? namespace}) async {
  debugPrint('[cache] set $key');
  key = namespaceKey(namespace, key);
  String? timeTag;
  final savedTag = await getSavedTag(key);
  if (savedTag != null) {
    timeTag = savedTag;
  } else {
    timeTag = uniqueExpirationTag();
    if (timeTag.isEmpty) return;
    await _timeDB.set(timeTag, key);
    await _cacheDB.set(tagKey(key), timeTag);
  }

  _cacheDB.set(key, value);
  _setCount++;
  if (_setCount > cleanupWhenSet) {
    _setCount = 0;
    await cleanup();
  }
}

/// uniqueExpirationTag return unique expiration time tag use in timeDB
@visibleForTesting
String uniqueExpirationTag() {
  int tag = DateTime.now().millisecondsSinceEpoch;
  for (int i = 0; i < 100; i++) {
    final tagStr = tag.toString();
    if (!_timeDB.contains(tagStr)) {
      return tagStr;
    }
    tag++;
  }
  return '';
}

/// contains return true if key is in cache
bool contains(dynamic key, {String? namespace}) => _cacheDB.contains(namespaceKey(namespace, key));

/// get returns the value associated with the given [key]. If the key does not exist, `null` is returned.
///
/// If [defaultValue] is specified, it is returned in case the key does not exist.
Future<dynamic> get(dynamic key, {dynamic defaultValue, String? namespace}) =>
    _cacheDB.get(namespaceKey(namespace, key), defaultValue: defaultValue);

/// deletes the given [key] from the box , If it does not exist, nothing happens.
Future<void> delete(dynamic key, {String? namespace}) async {
  debugPrint('[cache] delete $key');
  key = namespaceKey(namespace, key);
  final savedTag = await getSavedTag(key);
  if (savedTag != null) {
    await _timeDB.delete(savedTag);
  }
  await _cacheDB.delete(key);
  await _cacheDB.delete(tagKey(key));
}

/// cleanup deletes 10 expired items
Future<void> cleanup() async {
  int deleteCount = 0;
  final yearBefore = DateTime.now().add(const Duration(days: -365)).millisecondsSinceEpoch;
  for (int i = 0; i < _timeDB.length; i++) {
    final expirationTimeTag = await _timeDB.keyAt(i);
    final expirationTime = int.parse(expirationTimeTag);
    if (expirationTime > yearBefore || deleteCount > cleanupMaxItem) {
      break;
    }
    final key = await _timeDB.get(expirationTimeTag);
    await _cacheDB.delete(key);
    await _cacheDB.delete(tagKey(key));
    await _timeDB.delete(expirationTimeTag);
    deleteCount++;
  }
  if (deleteCount > 0) {
    debugPrint('[cache] cleanup $deleteCount items');
  }
}

/// reset entire cache by remove cache file
@visibleForTesting
Future<void> reset() async {
  await _cacheDB.deleteFromDisk();
  await _timeDB.deleteFromDisk();
  _setCount = 0;
  await init();
}

/// length return cached item length
int get length => _cacheDB.length;

/// timeLength return timeDB length
@visibleForTesting
int get timeLength => _timeDB.length;

/// _setCount return current set count
@visibleForTesting
int get setCount => _setCount;

/// setTestItem set cached item for test
@visibleForTesting
Future<void> setTestItem(String timeTag, dynamic key, dynamic value) async {
  _timeDB.set(timeTag, key);
  _cacheDB.set(key, value);
  _cacheDB.set(tagKey(key), timeTag);
}
