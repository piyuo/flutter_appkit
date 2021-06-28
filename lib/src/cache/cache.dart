import 'dart:core';
import 'package:libcli/src/cache/memory-cache.dart';

/// _cache is the internal cache
final _cache = MemoryCache();

/// set the value, this is a FIFO cache, set the same key will make that key the latest key in [_cache]. the default expire duration is 5 minutes
///
///     cache.set("key1", "value1");
///
void set(dynamic key, dynamic value, {Duration? expire}) => _cache.set(key, value, expire: expire);

/// get the value associated with [key].
///
///     cache.set("key1", "value1");
///
dynamic get(dynamic key) => _cache.get(key);

/// Returns true if any of the key exists in cache
///
///     final found = cache.contains("key1");
///
bool contains(dynamic key) => _cache.contains(key);

/// length return number of entry in the cache
///
///     final len2 = cache.length;
///
int get length => _cache.length;

/// delete key
///
///     cache.delete("key1");
///
void delete(dynamic key) => _cache.delete(key);

/// beginWith return entry count that key begin with name
///
///     final count=cache.beginWith("A");
///
int beginWith(String name) => _cache.beginWith(name);
