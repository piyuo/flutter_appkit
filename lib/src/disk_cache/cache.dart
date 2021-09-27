import 'dart:core';
import 'memory_cache.dart';
import 'package:libcli/pb.dart' as pb;
import 'package:libcli/storage.dart' as storage;
import 'registries.dart';

/*

/// set the value, this is a FIFO cache, set the same key will make that key the latest key in [_cache]. the default expire duration is 5 minutes
///
///     cache.set("key1", "value1");
///
Future<void> add(String key, pb.Object obj, {Duration? expire}) async {
  final registries = loadRegistries();
  DateTime? expired = null;
  if (expire != null) {
    expired = DateTime.now().add(expire!);
  }
}
*/

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
