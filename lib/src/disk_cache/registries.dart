import 'dart:core';
import 'package:libcli/storage.dart' as storage;
import 'package:libcli/pb.dart' as pb;
import 'registry.dart';

const String _cached_key = 'disk_cache';

const String _items = 'i';

List<Registry>? _registries;

var maxCachedSize = maxCachedSizeForBrowser;

const maxCachedSizeForBrowser = 4 * 1024 * 1024; // 4M

const maxCachedSizeForNative = 100 * 1024 * 1024; // 100M

/// _cachedSize return current cached size
int _cachedSize() {
  int result = 0;
  for (var registry in _registries!) {
    result += registry.length;
  }
  return result * 2;
}

Future<void> _delete(Registry registry) async {
  _registries!.remove(registry);
  await storage.delete(registry.storageKey);
}

Future<void> _cleanExpired() async {
  for (var registry in _registries!) {
    if (registry.expired != null && registry.expired!.isBefore(DateTime.now().toUtc())) {
      await _delete(registry);
    }
  }
}

/// _removeOldest remove oldest item from registries, return true if remove success
Future<bool> _removeOldest() async {
  if (_registries!.isNotEmpty) {
    final first = _registries![0];
    await _delete(first);
    return true;
  }
  return false;
}

/// _prepareSpace return true if space is available
Future<bool> _prepareSpace(int requiredSize) async {
  await _cleanExpired();
  for (var i = 0; i < 1000; i++) {
    if (_cachedSize() + requiredSize < maxCachedSize) {
      return true;
    }
    if (!await _removeOldest()) {
      //nothing to delete
      break;
    }
  }
  return false;
}

/// _prepareSpace return true if space is available
Registry? _registryByKey(String key) {
  for (var registry in _registries!) {
    if (registry.key == key) {
      return registry;
    }
  }
  return null;
}

/// _saveRegistries save registries to local storage and make sure it's length small than max length
Future<void> _saveRegistries() async {
  _registries ??= [];
  final items = [];
  for (var registry in _registries!) {
    items.add(registry.toJsonMap());
  }
  await storage.setJSON(_cached_key, {_items: items});
}

Future<List<Registry>> _loadRegistries() async {
  if (_registries == null) {
    _registries = [];
    final record = await storage.getJSON(_cached_key);
    if (record != null) {
      var items = record[_items];
      for (var json in items!) {
        final registry = Registry();
        _registries!.add(registry);
        registry.fromJsonMap(json);
      }
    }
  }
  return _registries!;
}

/// add string to cache
Future<bool> add(String key, String base64Str, {Duration? expire}) async {
  DateTime? expired;
  if (expire != null) {
    expired = DateTime.now().add(expire).toUtc();
  }

  Registry registry = Registry(
    key: key,
    expired: expired,
    length: base64Str.length,
  );

  final registries = await _loadRegistries();
  if (registry.length > maxCachedSize || !await _prepareSpace(registry.length)) {
    return false;
  }
  registries.add(registry);
  await _saveRegistries();
  await storage.setJSON(registry.storageKey, {'b': base64Str});
  return true;
}

/// get string from cache
Future<String?> get(String key) async {
  final registries = await _loadRegistries();

  Registry? registry = _registryByKey(key);
  if (registry == null) {
    return null;
  }

  if (registry.expired != null && registry.expired!.isBefore(DateTime.now().toUtc())) {
    _delete(registry);
    await _saveRegistries();
    return null;
  }
/*
//  return await storage.get(registry.storageKey);
  ;
  if (registry.length > maxCachedSize || !await _prepareSpace(registry.length)) {
    return false;
  }
  await storage.set(registry.storageKey, {'b': b64});
  registries.add(registry);
  await _saveRegistries();
  return true;
*/
}
