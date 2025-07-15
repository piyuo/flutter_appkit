// =============================================================
// File: preferences.dart
// Overview: Shared Preferences utility functions for persistent
// key-value storage in Flutter apps. Handles primitives, lists,
// maps, expiration, and test initialization.
//
// Sections:
//   - Exception definitions
//   - Constants
//   - Test initialization
//   - Primitive get/set/remove
//   - Expiration support
//   - DateTime helpers
//   - List/map helpers
//   - Clear all
// =============================================================

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logger.dart';

/// Exception thrown when a disk error occurs (e.g., out of space or permission denied).
class DiskErrorException implements Exception {}

/// Suffix for expiration keys used in setStringWithExpiration.
const expirationExt = '_EXP';

/// Initializes mock values for testing SharedPreferences.
///
/// Example:
///   initForTest({'key': 'value'});
@visibleForTesting
void initForTest(Map<String, Object> values) {
  // ignore:invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(values);
}

/// Returns true if the given key exists in preferences.
/// ```dart
///     bool found = await preferences.containsKey('k');
///
Future<bool> prefContainsKey(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.containsKey(key);
}

/// Removes the value for the given key from preferences.
/// ```dart
/// var result = await preferences.remove('k');
/// ```
Future<bool> prefRemoveKey(String key) async {
  assert(key.isNotEmpty);
  logInfo('[preferences] remove $key');
  final instance = await SharedPreferences.getInstance();
  return await instance.remove(key);
}

/// Gets a boolean value from preferences.
/// ```dart
/// var result = await preferences.getBool('k');
/// ```
Future<bool?> prefGetBool(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.getBool(key);
}

/// Sets a boolean value in preferences. Removes the key if [value] is null.
/// ```dart
/// await preferences.setBool('k',true);
/// ```
Future<void> prefSetBool(String key, bool? value) async {
  assert(key.isNotEmpty);
  logInfo('[preferences] set $key=$value');
  if (value == null) {
    prefRemoveKey(key);
    return;
  }
  final instance = await SharedPreferences.getInstance();
  var result = await instance.setBool(key, value);
  if (!result) {
    throw DiskErrorException();
  }
}

/// Gets an integer value from preferences.
/// ```dart
/// var result = await preferences.getInt('k');
/// ```
Future<int?> prefGetInt(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.getInt(key);
}

/// Sets an integer value in preferences. Removes the key if [value] is null.
/// ```dart
/// await preferences.setInt('k',1);
/// ```
Future<void> prefSetInt(String key, int? value) async {
  assert(key.isNotEmpty);
  logInfo('[preferences] set $key=$value');
  if (value == null) {
    prefRemoveKey(key);
    return;
  }
  final instance = await SharedPreferences.getInstance();
  var result = await instance.setInt(key, value);
  if (!result) {
    throw DiskErrorException();
  }
}

/// Gets a double value from preferences.
/// ```dart
/// var result = await preferences.getDouble('k');
/// ```
Future<double?> prefGetDouble(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.getDouble(key);
}

/// Sets a double value in preferences. Removes the key if [value] is null.
/// ```dart
/// await preferences.setDouble('k',1);
/// ```
Future<void> prefSetDouble(String key, double? value) async {
  assert(key.isNotEmpty);
  logInfo('[preferences] set $key=$value');
  if (value == null) {
    prefRemoveKey(key);
    return;
  }
  final instance = await SharedPreferences.getInstance();
  var result = await instance.setDouble(key, value);
  if (!result) {
    throw DiskErrorException();
  }
}

/// Gets a string value from preferences.
/// ```dart
/// var result = await preferences.getString('k');
/// ```
Future<String?> prefGetString(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.getString(key);
}

/// Sets a string value in preferences. Removes the key if [value] is null.
/// ```dart
/// await preferences.setString('k','value');
/// ```
Future<void> prefSetString(String key, String? value) async {
  assert(key.isNotEmpty);
  logInfo('[preferences] set $key=$value');
  if (value == null) {
    prefRemoveKey(key);
    return;
  }
  final instance = await SharedPreferences.getInstance();
  var result = await instance.setString(key, value);
  if (!result) {
    throw DiskErrorException();
  }
}

/// Gets a string value with expiration. Returns null if expired or not found.
/// ```dart
/// final str = await preferences.getStringWithExp('k');
/// ```
Future<String?> prefGetStringWithExp(String key) async {
  var exp = await prefGetDateTime(key + expirationExt);
  if (exp != null) {
    final now = DateTime.now();
    if (exp.isBefore(now)) {
      //expired
      prefRemoveKey(key);
      prefRemoveKey(key + expirationExt);
      return null;
    }
  }
  return await prefGetString(key);
}

/// Sets a string value with an expiration date.
/// ```dart
/// await preferences.setStringWithExp('k', 'a', exp);
/// ```
Future<void> prefSetStringWithExp(String key, String value, DateTime expire) async {
  await prefSetDateTime(key + expirationExt, expire);
  await prefSetString(key, value);
}

/// Gets a DateTime value from preferences, or null if not found.
/// ```dart
/// var result = await preferences.getDateTime('k');
/// ```
Future<DateTime?> prefGetDateTime(String key) async {
  var value = await prefGetString(key);
  if (value != null) {
    return DateTime.parse(value);
  }
  return null;
}

/// Sets a DateTime value in preferences. Removes the key if [value] is null.
/// ```dart
/// await preferences.setDateTime('k', DateTime.now());
/// ```
Future<void> prefSetDateTime(String key, DateTime? value) async {
  assert(key.isNotEmpty);
  if (value == null) {
    prefRemoveKey(key);
    return;
  }
  String formatted = value.toString().substring(0, 19);
  return await prefSetString(key, formatted);
}

/// Gets a list of strings from preferences.
/// ```dart
/// var result = await preferences.getStringList('k');
/// ```
Future<List<String>?> prefGetStringList(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.getStringList(key);
}

/// Sets a list of strings in preferences. Removes the key if [value] is null.
/// ```dart
/// await preferences.setStringList('k',list);
/// ```
Future<void> prefSetStringList(String key, List<String> value) async {
  assert(key.isNotEmpty);
  logInfo('[preferences] set $key=$value');
  final instance = await SharedPreferences.getInstance();
  var result = await instance.setStringList(key, value);
  if (!result) {
    throw DiskErrorException();
  }
}

/// Gets a Map from preferences (decoded from JSON), or null if not found.
/// ```dart
/// var result = await preferences.getMap('k');
/// ```
Future<dynamic> prefGetMap(String key) async {
  final j = await prefGetString(key);
  if (j != null) {
    return jsonDecode(j);
  }
  return null;
}

/// Sets a Map in preferences (encoded as JSON). Removes the key if [map] is null.
/// ```dart
/// await preferences.setMap('k',map);
/// ```
Future<void> prefSetMap(String key, Map<String, dynamic> map) async {
  String j = json.encode(map);
  return await prefSetString(key, j);
}

/// Gets a list of Maps from preferences (each decoded from JSON), or null if not found.
/// ```dart
/// var result = await preferences.getMapList('k');
/// ```
Future<List<Map<String, dynamic>>?> prefGetMapList(String key) async {
  var list = await prefGetStringList(key);
  if (list != null) {
    return list.map((e) => json.decode(e) as Map<String, dynamic>).toList();
  }
  return null;
}

/// Sets a list of Maps in preferences (each encoded as JSON). Removes the key if [mapList] is null.
/// ```dart
/// await preferences.setMapList('k',list);
/// ```
Future<void> prefSetMapList(String key, List<Map<String, dynamic>> mapList) async {
  List<String> list = mapList.map((e) => json.encode(e)).toList();
  return await prefSetStringList(key, list);
}

/// Clears all preferences. Returns true if successful.
/// ```dart
/// await preferences.clear();
/// ```
Future<bool> prefClear() async {
  final instance = await SharedPreferences.getInstance();
  return await instance.clear();
}
