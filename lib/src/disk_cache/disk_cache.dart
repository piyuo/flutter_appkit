import 'dart:core';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:libcli/storage.dart' as storage;
import 'package:libcli/log.dart' as log;
import 'package:libcli/i18n.dart' as i18n;
import 'registry.dart';

const String cached_key = 'disk_cache';

const String _items = 'i';

/// _registries keep track all registry and cache object
List<Registry>? _registries;

/// mockRegistries reveal registries for testing
@visibleForTesting
set mockRegistries(List<Registry>? value) => _registries = value;

/// mockRegistries reveal registries for testing
@visibleForTesting
List<Registry> get mockRegistries => _registries!;

/// maxCachedSize allow in cache
var maxCachedSize = maxCachedSizeForBrowser;

/// maxCachedSizeForBrowser is max cache size for browser
const maxCachedSizeForBrowser = 4 * 1024 * 1024; // 4M

/// maxCachedSizeForNative is max cache size for native app
const maxCachedSizeForNative = 100 * 1024 * 1024; // 100M

/// cachedSize return current cached size
@visibleForTesting
int cachedSize() {
  assert(_registries != null, 'call _loadRegistries() first');
  int result = 0;
  for (var registry in _registries!) {
    result += registry.size;
  }
  return result;
}

/// deleteRegistry registry from cache
@visibleForTesting
Future<void> deleteRegistry(Registry registry) async {
  log.debug('disk_cache delete ${registry.key}');
  _registries!.remove(registry);
  await storage.delete(registry.storageKey);
}

/// containsRegistryKey return true if key exists
@visibleForTesting
Future<bool> containsRegistryKey(String key) async {
  return registryByKey(key) != null;
}

/// cleanExpired  clean expired registry
@visibleForTesting
Future<void> cleanExpired() async {
  for (var i = _registries!.length - 1; i >= 0; i--) {
    final registry = _registries![i];
    if (registry.expired.isBefore(DateTime.now().toUtc())) {
      await deleteRegistry(registry);
    }
  }
}

/// removeOldest remove oldest item from registries, return true if remove success
@visibleForTesting
Future<bool> removeOldest() async {
  if (_registries!.isNotEmpty) {
    final first = _registries![0];
    await deleteRegistry(first);
    return true;
  }
  return false;
}

/// prepareSpace return true if space is available
@visibleForTesting
Future<bool> prepareSpace(int requiredSize) async {
  await cleanExpired();
  for (var i = 0; i < 1000; i++) {
    if (cachedSize() + requiredSize < maxCachedSize) {
      return true;
    }
    if (!await removeOldest()) {
      //nothing to delete
      break;
    }
  }
  return false;
}

/// registryByKey return registry by key
@visibleForTesting
Registry? registryByKey(String key) {
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
  await storage.setJSON(cached_key, {_items: items});
}

Future<List<Registry>> _loadRegistries() async {
  if (_registries == null) {
    _registries = [];
    final record = await storage.getJSON(cached_key);
    if (record != null) {
      var items = record[_items];
      for (var json in items!) {
        final registry = Registry.fromJson(json);
        _registries!.add(registry);
      }
    }
  }
  return _registries!;
}

/// add json to cache, return registry if success
Future<Registry?> add(
  String key,
  Map<String, dynamic> serializable, {
  Duration expire = const Duration(days: 31),
}) async {
  assert(key.isNotEmpty, 'key must not empty');
  final cacheContent = json.encode(serializable);
  Registry registry = Registry(
    key: key,
    expired: DateTime.now().add(expire).toUtc(),
    size: cacheContent.length * 2,
  );

  final registries = await _loadRegistries();
  if (registry.size > maxCachedSize || !await prepareSpace(registry.size)) {
    return null;
  }

  final duplicate = registryByKey(registry.key);
  if (duplicate != null) {
    await deleteRegistry(duplicate);
  }
  registries.add(registry);
  log.debug('disk_cache add ${registry.key} (${i18n.formatBytes(registry.size, 0)})');
  try {
    await storage.setJSON(registry.storageKey, serializable);
    await _saveRegistries();
  } catch (e, s) {
    // something wrong,maybe disk full, the size limit may not correct
    await removeOldest();
    log.error(e, s);
  }
  return registry;
}

/// get json from cache
Future<Map<String, dynamic>?> get(String key) async {
  await _loadRegistries();
  Registry? registry = registryByKey(key);
  if (registry == null) {
    return null;
  }
  if (registry.expired.isBefore(DateTime.now().toUtc())) {
    await deleteRegistry(registry);
    await _saveRegistries();
    return null;
  }
  return await storage.getJSON(registry.storageKey);
}

/// cachedItem return cached item
@visibleForTesting
Future<Map<String, dynamic>?> cachedItem(Registry registry) async {
  return await storage.getJSON(registry.storageKey);
}
