import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:libcli/utils/utils.dart' as utils;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/data/data.dart' as data;
import 'package:hive/hive.dart';

/// _cleanupMaxItem is the maximum number of items to delete in every cleanup
int _cleanupMaxItem = kIsWeb ? 50 : 500; // web is slow, clean 50 may tak 3 sec. native is much faster

/// MemoryProvider provide cache memory
class MemoryProvider with ChangeNotifier, utils.NeedInitializeMixin {
  MemoryProvider({
    String cacheDBName = 'cache',
    String timeDBName = 'time',
  }) {
    initFuture = () async {
      _cacheBox = await data.openBox(cacheDBName);
      _timeBox = await data.openBox(timeDBName);
    };
  }

  /// _cacheBox keep all cached data
  late LazyBox _cacheBox;

  /// _timeBox keep track cached item expired time
  late LazyBox _timeBox;

  /// _lock is lock for async operation
  final _lock = Lock();

  /// dispose database and reset counter
  @override
  void dispose() {
    data.closeBox(_cacheBox);
    data.closeBox(_timeBox);
    super.dispose();
  }

  /// of get instance from context
  static MemoryProvider of(BuildContext context) {
    return Provider.of<MemoryProvider>(context, listen: false);
  }

  /// length return cached item length
  int get length => _cacheBox.length;

  /// timeLength return timeDB length
  @visibleForTesting
  int get timeLength => _timeBox.length;

  /// reset entire cache by remove cache content (not entire db)
  /// ```dart
  /// await reset();
  /// ```
  @visibleForTesting
  Future<void> reset() async {
    await _lock.synchronized(() async {
      await data.resetBox(_cacheBox);
      await data.resetBox(_timeBox);
    });
  }

  /// setTestString set cached item for test
  @visibleForTesting
  Future<void> setTestString(String timeTag, String key, dynamic value) async {
    await _timeBox.put(timeTag, key);
    await _cacheBox.put(key, value);
    await _cacheBox.put(tagKey(key), timeTag);
  }

  /// compact deletes 50 expired items
  /// ```dart
  /// await cache.compact();
  /// ```
  Future<void> compact() async {
    int deleteCount = 0;
    final yearBefore = DateTime.now().add(const Duration(days: -365)).millisecondsSinceEpoch;
    for (int i = 0; i < _timeBox.length; i++) {
      final expirationTimeTag = await _timeBox.keyAt(i);
      final expirationTime = int.parse(expirationTimeTag);
      if (expirationTime > yearBefore || deleteCount > _cleanupMaxItem) {
        break;
      }
      final key = await _timeBox.get(expirationTimeTag);
      if (key != null) {
        await _cacheBox.delete(key);
        await _cacheBox.delete(tagKey(key));
      }
      await _timeBox.delete(expirationTimeTag);
      deleteCount++;
    }
    if (deleteCount > 0) {
      debugPrint('[cache] memory cleanup $deleteCount items');
    }
  }

  /// tagKey return key that store time tag
  @visibleForTesting
  String tagKey(String key) => '${key}_tag';

  /// getSavedTag get saved tag
  @visibleForTesting
  Future<String?> getSavedTag(String key) async => await _cacheBox.get(tagKey(key));

  /// put saves the [key] - [value] pair
  /// ```dart
  /// await put<bool>('k', true);
  /// ```
  Future<void> put<T>(String key, T value) async =>
      await _addTimeTag(key, (newKey) async => _cacheBox.put(newKey, value));

  /// _addTimeTag saves the [key] - [value] pair with time tag
  Future<void> _addTimeTag(String key, Future<void> Function(String) setValueCallback) async {
    await _lock.synchronized(() async {
      String? timeTag;
      final savedTag = await getSavedTag(key);
      if (savedTag != null) {
        timeTag = savedTag;
      } else {
        timeTag = uniqueExpirationTag();
        if (timeTag.isEmpty) return;
        await _timeBox.put(timeTag, key);
        await _cacheBox.put(tagKey(key), timeTag);
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
      if (!_timeBox.containsKey(tagStr)) {
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
  bool containsKey(dynamic key) => _cacheBox.containsKey(key);

  /// get returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  /// ```dart
  /// expect(await getBool('k'), true);
  /// ```
  Future<T?> get<T>(String key) async => await _cacheBox.get(key);

  /// setObject saves the [key] - [value] pair
  /// ```dart
  /// await setObject('k', sample.Person(name: 'john'));
  /// ```
  Future<void> putObject(String key, pb.Object value) async =>
      await _addTimeTag(key, (newKey) async => data.putBoxObject(_cacheBox, newKey, value));

  /// getObject returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  /// ```dart
  /// expect(await getObject<sample.Person>('k', () => sample.Person())!.name, 'john');
  /// ```
  Future<T?> getObject<T extends pb.Object>(String key, pb.Builder<T> builder) async =>
      await data.getBoxObject(_cacheBox, key, builder);

  /// deletes the given [key] from the box , If it does not exist, nothing happens.
  Future<void> delete(String key) async {
    await _lock.synchronized(() async {
      key = key;
      final savedTag = await getSavedTag(key);
      if (savedTag != null) {
        await _timeBox.delete(savedTag);
      }
      await _cacheBox.delete(key);
      await _cacheBox.delete(tagKey(key));
    });
  }

  /// removeBox remove db box file
  /// ```dart
  /// await removeBox();
  /// ```
  @visibleForTesting
  Future<void> removeBox() async {
    await data.deleteBox(_cacheBox);
    await data.deleteBox(_timeBox);
  }
}
