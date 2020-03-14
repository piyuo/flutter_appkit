import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libcli/log/log.dart';
import 'package:libcli/hook/events.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventBus;
import 'package:flutter/material.dart';

const _here = 'data';

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
  '$_here|get $NOUN$key=$value'.print;
  return value;
}

/// getInt return int value from data
///
///     var result = await data.getInt('k');
///
Future<int> getInt(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getInt(key) ?? 0;
  '$_here|get $NOUN$key=$value'.print;
  return value;
}

/// getDouble return double value from data
///
///     var result = await data.getDouble('k');
///
Future<double> getDouble(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getDouble(key) ?? 0;
  '$_here|get $NOUN$key=$value'.print;
  return value;
}

/// getString return string value from data
///
///     var result = await data.getString('k');
///
Future<String> getString(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getString(key) ?? '';
  '$_here|get $NOUN$key=$value'.print;
  return value;
}

/// getStringList return string list from data
///
///     var result = await data.getStringList('k');
///
Future<List<String>> getStringList(String key) async {
  assert(key.length > 0);
  var value = (await _get()).getStringList(key) ?? [];
  '$_here|get $NOUN$key=$value'.print;
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
///     await data.setBool(ctx,'k',true);
///
setBool(BuildContext ctx, String key, bool value) async {
  assert(key.length > 0);
  '$_here|set $key=$NOUN$value'.print;
  var result = (await (await _get()).setBool(key, value));
  if (!result) {
    eventBus.broadcast(ctx, EDiskFullOrNoAccess());
  }
}

/// setInt set int value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setInt(ctx,'k',1);
///
setInt(BuildContext ctx, String key, int value) async {
  assert(key.length > 0);
  '$_here|set $NOUN$key=$value'.print;
  var result = (await (await _get()).setInt(key, value));
  if (!result) {
    eventBus.broadcast(ctx, EDiskFullOrNoAccess());
  }
}

/// setDouble set double value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setDouble(ctx,'k',1);
///
setDouble(BuildContext ctx, String key, double value) async {
  assert(key.length > 0);
  '$_here|set $NOUN$key=$value'.print;
  var result = (await (await _get()).setDouble(key, value));
  if (!result) {
    eventBus.broadcast(ctx, EDiskFullOrNoAccess());
  }
}

/// setString set string value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setString(ctx,'k','value');
///
setString(BuildContext ctx, String key, String value) async {
  assert(key.length > 0);
  '$_here|set $NOUN$key=$value'.print;
  var result = (await (await _get()).setString(key, value));
  if (!result) {
    eventBus.broadcast(ctx, EDiskFullOrNoAccess());
  }
}

/// setStringList set string list to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setStringList(ctx,'k',list);
///
setStringList(BuildContext ctx, String key, List<String> value) async {
  assert(key.length > 0);
  '$_here|set $NOUN$key=$value'.print;
  var result = (await (await _get()).setStringList(key, value));
  if (!result) {
    eventBus.broadcast(ctx, EDiskFullOrNoAccess());
  }
}

/// setMap set string map to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setMap('k',map);
///
Future<void> setMap(
    BuildContext ctx, String key, Map<String, dynamic> map) async {
  // String json = JsonEncoder.withIndent('').convert(map);
  String j = json.encode(map);
  return await setString(ctx, key, j);
}

/// mockInit Initializes the value for testing
///
///     data.mockInit({});
///
@visibleForTesting
void mockInit(Map<String, dynamic> values) {
  SharedPreferences.setMockInitialValues(values);
}
