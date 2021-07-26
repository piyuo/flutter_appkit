import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libcli/log.dart' as log;

/// _expirationExt is for setStringWithExpiration, we need extra expiration time
const expirationExt = '_EXP';

/// _instance provide SharedPreferences instance
///
var _instance;

/// _get lazy loading SharedPreferences instance
///
Future<SharedPreferences> _get() async {
  if (_instance == null) {
    _instance = await SharedPreferences.getInstance();
  }
  return _instance;
}

/// mock Initializes the value for testing
///
///     prefs.mock({});
///
@visibleForTesting
void mock(Map<String, Object> values) {
  // ignore:invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(values);
}

/// containsKey return true if key exists
///
///     bool found = await pref.containsKey('k');
///
Future<bool> containsKey(String key) async {
  assert(key.length > 0);
  return (await _get()).containsKey(key);
}

/// remove value from preferences
///
///     var result = await pref.remove('k');
///
Future<bool> remove(String key) async {
  assert(key.length > 0);
  log.log('[pref] remove $key');
  return (await _get()).remove(key);
}

/// getBool return boolean value from preferences
///
///     var result = await pref.getBool('k');
///
Future<bool> getBool(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getBool(key) ?? false;
  log.log('[pref] get $key=$value');
  return value;
}

/// setBool set boolean value to preferences, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await pref.setBool('k',true);
///
Future<void> setBool(String key, bool value) async {
  assert(key.length > 0);
  log.log('[pref] set $key=$value');
  var result = (await (await _get()).setBool(key, value));
  if (!result) {
    throw log.DiskErrorException();
  }
}

/// getInt return int value from preferences
///
///     var result = await pref.getInt('k');
///
Future<int> getInt(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getInt(key) ?? 0;
  log.log('[pref] get $key=$value');
  return value;
}

/// setInt set int value to preferences, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await pref.setInt('k',1);
///
Future<void> setInt(String key, int value) async {
  assert(key.length > 0);
  log.log('[pref] set $key=$value');
  var result = (await (await _get()).setInt(key, value));
  if (!result) {
    throw log.DiskErrorException();
  }
}

/// getDouble return double value from preferences
///
///     var result = await pref.getDouble('k');
///
Future<double> getDouble(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getDouble(key) ?? 0;
  log.log('[pref] get $key=$value');
  return value;
}

/// setDouble set double value to preferences, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await pref.setDouble('k',1);
///
Future<void> setDouble(String key, double value) async {
  assert(key.length > 0);
  log.log('[pref] set $key=$value');
  var result = (await (await _get()).setDouble(key, value));
  if (!result) {
    throw log.DiskErrorException();
  }
}

/// getString return string value from preferences
///
///     var result = await pref.getString('k');
///
Future<String> getString(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getString(key) ?? '';
  log.log('[pref] get $key=$value');
  return value;
}

/// setString set string value to preferences, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await pref.setString('k','value');
///
Future<void> setString(String key, String value) async {
  assert(key.length > 0);
  log.log('[pref] set $key=$value');
  var result = (await (await _get()).setString(key, value));
  if (!result) {
    throw log.DiskErrorException();
  }
}

/// getStringWithExp return string value from preferences and check expiration date
///
///     final str = await getStringWithExp('k');
///
Future<String> getStringWithExp(String key) async {
  var exp = await getDateTime(key + expirationExt);
  if (exp != null) {
    final now = DateTime.now();
    if (exp.isBefore(now)) {
      //expired
      remove(key);
      remove(key + expirationExt);
      return '';
    }
  }
  return await getString(key);
}

/// setStringWithExp set string value to preferences with a expiration date
///
///     await setStringWithExp('k', 'a', exp);
///
Future<void> setStringWithExp(String key, String value, DateTime expire) async {
  await setDateTime(key + expirationExt, expire);
  await setString(key, value);
}

/// getDateTime return datetime value from preferences. return 1970/01/01 Epoch if not exist
///
///     var result = await pref.getDateTime('k');
///
Future<DateTime?> getDateTime(String key) async {
  var value = await getString(key);
  if (value.length > 0) {
    return DateTime.parse(value);
  }
  return null;
}

/// setDateTime set datetime value to preference, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await pref.setDateTime('k', DateTime.now());
///
setDateTime(String key, DateTime value) async {
  assert(key.length > 0);
  String formatted = value.toString().substring(0, 19);
  return await setString(key, formatted);
}

/// getStringList return string list from data
///
///     var result = await pref.getStringList('k');
///
Future<List<String>> getStringList(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getStringList(key) ?? [];
  log.log('[pref] get $key=$value');
  return value;
}

/// setStringList set string list to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await pref.setStringList('k',list);
///
setStringList(String key, List<String> value) async {
  assert(key.length > 0);
  log.log('[pref] set $key=$value');
  var result = (await (await _get()).setStringList(key, value));
  if (!result) {
    throw log.DiskErrorException();
  }
}

/// getMap return map from data
///
///     var result = await pref.getMap('k');
///
Future<Map<String, dynamic>> getMap(String key) async {
  var j = await getString(key);
  return jsonDecode(j);
}

/// setMap set string map to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await pref.setMap('k',map);
///
Future<void> setMap(String key, Map<String, dynamic> map) async {
  String j = json.encode(map);
  return await setString(key, j);
}
