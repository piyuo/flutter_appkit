import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/log/color.dart';

const _here = 'data';

class DataException implements Exception {}

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

/// getBool return boolean value from data
///
///     var result = await data.getBool('k');
///
Future<bool> getBool(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getBool(key) ?? false;
  log.debug(_here, 'get $key=$YELLOW$value');
  return value;
}

/// getInt return int value from data
///
///     var result = await data.getInt('k');
///
Future<int> getInt(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getInt(key) ?? 0;
  log.debug(_here, 'get $key=$YELLOW$value');
  return value;
}

/// getDouble return double value from data
///
///     var result = await data.getDouble('k');
///
Future<double> getDouble(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getDouble(key) ?? 0;
  log.debug(_here, 'get $key=$YELLOW$value');
  return value;
}

/// getString return string value from data
///
///     var result = await data.getString('k');
///
Future<String> getString(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getString(key) ?? '';
  log.debug(_here, 'get $key=$YELLOW$value');
  return value;
}

/// getStringList return string list from data
///
///     var result = await data.getStringList('k');
///
Future<List<String>> getStringList(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getStringList(key) ?? [];
  log.debug(_here, 'get $key=$YELLOW$value');
  return value;
}

/// getMap return map from data
///
///     var result = await data.getMap('k');
///
Future<Map<String, dynamic>> getMap(String key) async {
  var j = await getString(key);
  return jsonDecode(j);
}

/// setBool set boolean value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setBool('k');
///
Future<void> setBool(String key, bool value) async {
  assert(key.length > 0);
  log.debug(_here, 'set $key=$YELLOW$value');
  if (!await (await _get()).setBool(key, value)) {
    throw DataException();
  }
}

/// setInt set int value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setInt('k');
///
Future<void> setInt(String key, int value) async {
  assert(key.length > 0);
  log.debug(_here, 'set $key=$YELLOW$value');
  if (!await (await _get()).setInt(key, value)) {
    throw DataException();
  }
}

/// setDouble set double value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setDouble('k');
///
Future<void> setDouble(String key, double value) async {
  assert(key.length > 0);
  log.debug(_here, 'set $key=$YELLOW$value');
  if (!await (await _get()).setDouble(key, value)) {
    throw DataException();
  }
}

/// setString set string value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setString('k');
///
Future<void> setString(String key, String value) async {
  assert(key.length > 0);
  log.debug(_here, 'set $key=$YELLOW$value');
  if (!await (await _get()).setString(key, value)) {
    throw DataException();
  }
}

/// setStringList set string list to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setStringList('k');
///
Future<void> setStringList(String key, List<String> value) async {
  assert(key.length > 0);
  log.debug(_here, 'set $key=$YELLOW$value');
  if (!await (await _get()).setStringList(key, value)) {
    throw DataException();
  }
}

/// setMap set string map to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setMap('k');
///
Future<void> setMap(String key, Map<String, dynamic> map) async {
  // String json = JsonEncoder.withIndent('').convert(map);
  String j = json.encode(map);
  return await setString(key, j);
}
