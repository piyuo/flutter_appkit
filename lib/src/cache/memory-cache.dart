import 'dart:core';
import 'dart:async';
import 'dart:collection';
import 'package:clock/clock.dart';

class MemoryCache {
  /// _clock uses to compute expire
  final Clock _clock = const Clock();

  /// maxCacheLimit is size limit of [_cache]
  final int maxCacheLimit;

  /// _expiredCheck check expired entry every 3 minutes
  var expiredCheck;

  /// _cache is the internal cache
  final _cache = LinkedHashMap<dynamic, dynamic>();

  MemoryCache({
    this.maxCacheLimit = 240,
    this.expiredCheck = const Duration(minutes: 3),
  }) {
    Timer.periodic(expiredCheck, (Timer t) {
      // cache are LinkedHashMap which is by time order. So we just need to stop on the first not expired value
      _cache.keys.takeWhile((value) => _isExpired(value)).toList().forEach(_cache.remove);
    });
  }

  /// set the value, this is a FIFO cache, set the same key will make that key the latest key in [_cache]. the default expire duration is 5 minutes
  //
  void set(
    dynamic key,
    dynamic value, {
    Duration? expire,
  }) {
    expire = expire ?? Duration(minutes: 5);
    // make sure it be the last one in cache
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    }
    _cache[key] = _MemoryCacheEntry(value, _clock.now(), expire);
    if (_cache.length > maxCacheLimit) {
      _cache.remove(_cache.keys.first);
    }
  }

  /// get the value associated with [key].
  ///
  dynamic get(dynamic key) {
    if (_cache.containsKey(key) && _isExpired(key)) {
      _cache.remove(key);
      return null;
    }
    return _cache[key]?._obj;
  }

  /// Returns true if any of the key exists in cache
  bool contains(dynamic key) => _cache.containsKey(key);

  /// length return number of entry in the cache
  int get length => _cache.length;

  /// _isExpired return true if entry is expired
  bool _isExpired(dynamic key) => _clock.now().difference(_cache[key]!._created) > _cache[key]!._expire;

  /// delete key
  void delete(dynamic key) {
    _cache.remove(key);
  }

  /// beginWith return entry count that key begin with name
  int beginWith(String name) {
    int count = 0;
    for (var key in _cache.keys) {
      if (!_isExpired(key) && key is String && key.startsWith(name)) {
        count++;
      }
    }
    return count;
  }
}

class _MemoryCacheEntry {
  /// _obj is cached object
  final _obj;

  /// _created is entry create time
  final DateTime _created;

  /// The duration between entry create and expire. Default is 5 minutes
  final Duration _expire;

  _MemoryCacheEntry(this._obj, this._created, this._expire);
}
