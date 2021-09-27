import 'dart:core';
import 'package:libcli/storage.dart' as storage;
import 'package:libcli/pb.dart' as pb;
import 'registry.dart';

const String _cached_key = 'disk_cache';

const String _items = 'i';

List<Registry>? _registries;

var maxLength = maxLengthForBrowser;

const maxLengthForBrowser = 4 * 1024 * 1024; // 4M

const maxLengthForNative = 100 * 1024 * 1024; // 100M

/// _registriesLength return registries length
int _registriesLength() {
  int result = 0;
  for (var registry in _registries!) {
    result += registry.length;
  }
  return result;
}

/// _removeOldest remove oldest item from registries
void _removeOldest() {
  if (_registries!.isNotEmpty) {
    final first = _registries![0];
    String key = _cached_key + '_' + first.key;
    _registries!.remove(_registries![0]);
  }
}

/// _limitRegistriesLength make sure registries length small than maxLength
void _limitRegistriesLength() {
  while (_registriesLength() > maxLength) {
    _removeOldest();
  }
}

/// _removeRegistry remove registry with key from _registries
void _removeRegistry(String key) async {
  for (final registry in _registries!) {
    if (registry.key == key) {
      _registries!.remove(registry);
      return;
    }
  }
}

/// _isKeyExists return true if key exists
bool _isKeyExists(String key) {
  for (final registry in _registries!) {
    if (registry.key == key) {
      return true;
    }
  }
  return false;
}

/// _saveRegistries save registries to local storage and make sure it's length small than max length
Future<void> _saveRegistries() async {
  _registries ??= [];
  _limitRegistriesLength();
  final items = [];
  for (var registry in _registries!) {
    items.add(registry.toJsonMap());
  }
  await storage.set(_cached_key, {_items: items});
}

Future<List<Registry>> _loadRegistries() async {
  if (_registries == null) {
    _registries = [];
    final record = await storage.get(_cached_key);
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
/*
///
Future<bool> add(String key, pb.Object object) async {



  final registries = await _loadRegistries();
  await _removeRegistry(registry.key);
  registries.add(registry);
  await _saveRegistries();
}
*/