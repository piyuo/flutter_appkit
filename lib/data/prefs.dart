import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libcli/log/log.dart';
import 'package:libcli/hook/errors.dart';

const _here = 'prefs';

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

/// getBool return boolean value from prefences
///
///     var result = await data.getBool('k');
///
Future<bool> getBool(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getBool(key) ?? false;
  debugPrint('$_here~get $NOUN$key=$value');
  return value;
}

/// setBool set boolean value to prefences, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setBool('k',true);
///
setBool(String key, bool value) async {
  assert(key.length > 0);
  debugPrint('$_here~set $key=$NOUN$value');
  var result = (await (await _get()).setBool(key, value));
  if (!result) {
    throw DiskFullException();
  }
}

/// getInt return int value from prefences
///
///     var result = await data.getInt('k');
///
Future<int> getInt(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getInt(key) ?? 0;
  debugPrint('$_here~get $NOUN$key=$value');
  return value;
}

/// setInt set int value to prefences, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setInt('k',1);
///
setInt(String key, int value) async {
  assert(key.length > 0);
  debugPrint('$_here~set $NOUN$key=$value');
  var result = (await (await _get()).setInt(key, value));
  if (!result) {
    throw DiskFullException();
  }
}

/// getDouble return double value from prefences
///
///     var result = await data.getDouble('k');
///
Future<double> getDouble(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getDouble(key) ?? 0;
  debugPrint('$_here~get $NOUN$key=$value');
  return value;
}

/// setDouble set double value to prefences, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setDouble('k',1);
///
setDouble(String key, double value) async {
  assert(key.length > 0);
  debugPrint('$_here~set $NOUN$key=$value');
  var result = (await (await _get()).setDouble(key, value));
  if (!result) {
    throw DiskFullException();
  }
}

/// getString return string value from prefences
///
///     var result = await data.getString('k');
///
Future<String> getString(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getString(key) ?? '';
  debugPrint('$_here~get $NOUN$key=$value');
  return value;
}

/// setString set string value to prefences, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setString('k','value');
///
setString(String key, String value) async {
  assert(key.length > 0);
  debugPrint('$_here~set $NOUN$key=$value');
  var result = (await (await _get()).setString(key, value));
  if (!result) {
    throw DiskFullException();
  }
}

/// getDateTime return datetime value from prefences
///
///     var result = await data.getString('k');
///
Future<DateTime> getDateTime(String key) async {
  var value = await getString(key);
  if (value != null && value.length > 0) {
    return DateTime.parse(value);
  }
  return null;
}

/// setDateTime set datatime value to preference, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setString('k','value');
///
setDateTime(String key, DateTime value) async {
  assert(key.length > 0);
  String formatted = null;
  if (value != null) {
    //var formatter = new DateFormat('yyyy-MM-dd HH:mm');
    //formatter.format(value);
    formatted = value.toString().substring(0, 16);
  }
  return await setString(key, formatted);
}

/// getStringList return string list from data
///
///     var result = await data.getStringList('k');
///
Future<List<String>> getStringList(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getStringList(key) ?? [];
  debugPrint('$_here~get $NOUN$key=$value');
  return value;
}

/// setStringList set string list to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setStringList('k',list);
///
setStringList(String key, List<String> value) async {
  assert(key.length > 0);
  debugPrint('$_here~set $NOUN$key=$value');
  var result = (await (await _get()).setStringList(key, value));
  if (!result) {
    throw DiskFullException();
  }
}

/// getMap return map from data
///
///     var result = await data.getMap('k');
///
Future<Map<String, dynamic>> getMap(String key) async {
  var j = await getString(key);
  return jsonDecode(j);
}

/// setMap set string map to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setMap('k',map);
///
Future<void> setMap(String key, Map<String, dynamic> map) async {
  String j = json.encode(map);
  return await setString(key, j);
}

/// mock Initializes the value for testing
///
///     data.mock({});
///
@visibleForTesting
void mock(Map<String, dynamic> values) {
  SharedPreferences.setMockInitialValues(values);
}
