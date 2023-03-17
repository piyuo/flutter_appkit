import 'dart:core';
import 'ram_provider.dart';

/// _cache is the internal cache
final _cache = RamProvider();

/// set the value, this is a FIFO cache, set the same key will make that key the latest key in [_cache]. the default expire duration is 5 minutes
/// ```dart
/// cache.set("key1", "value1");
/// ```
void put<T>(dynamic key, T? value, {Duration? expire}) => _cache.put(key, value, expire: expire);

/// get the value associated with [key].
/// ```dart
/// cache.set("key1", "value1");
/// ```
T? get<T>(dynamic key) => _cache.get(key);

/// containsKey returns true if any of the key exists in cache
/// ```dart
/// final found = cache.contains("key1");
/// ```
bool containsKey(dynamic key) => _cache.containsKey(key);

/// length return number of entry in the cache
/// ```dart
/// final len2 = cache.length;
/// ```
int get length => _cache.length;

/// delete key
/// ```dart
/// cache.delete("key1");
/// ```
void delete(dynamic key) => _cache.delete(key);

/// beginWith return entry count that key begin with name
/// ```dart
/// final count=cache.beginWith("A");
/// ```
int beginWith(String name) => _cache.beginWith(name);
