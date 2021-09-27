import 'dart:core';
import 'memory_cache.dart';
import 'package:libcli/pb.dart' as pb;
import 'package:libcli/storage.dart' as storage;
import 'registries.dart';

/// add to the cache, this is a FIFO cache, return true if success save to cache, it will not save if object's base64 string exceed maxCachedSize
///
///     cache.add("key1", object);
///
Future<bool> add(String key, pb.Object obj, {Duration? expire}) async {
  final list = [obj.toBase64()];
  return await saveToCache(key, list, expire: expire);
}

/// addList to the cache, this is a FIFO cache, return true if success save to cache, it will not save if object's base64 string exceed maxCachedSize
///
///     cache.addList("key1", list);
///
Future<bool> addList(String key, List<pb.Object> objList, {Duration? expire}) async {
  final list = <String>[];
  for (final obj in objList) {
    list.add(obj.toBase64());
  }
  return await saveToCache(key, list, expire: expire);
}

/// get object from cache. obj can be a empty object
///
///     cache.add("key1", object);
///
Future<bool> get(String key, pb.Object obj) async {
  final list = await loadFromCache(key);
  if (list == null || list.isEmpty) {
    return false;
  }
  obj.fromBase64(list[0]);
  return true;
}

/// _cache is the internal cache
final _cache = MemoryCache();

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
