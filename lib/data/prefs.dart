import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libcli/log/log.dart';
import 'package:libcli/hook/events.dart';
import 'package:libcli/hook/contracts.dart';
import 'package:libcli/eventbus/event_bus.dart' as eventBus;

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
///     await data.setBool('k',true);
///
Future<bool> setBool(String key, bool value) async {
  assert(key.length > 0);
  '$_here|set $key=$NOUN$value'.print;
  var result = (await (await _get()).setBool(key, value));
  if (!result) {
    eventBus.broadcast(EDiskFullOrNoAccess());
  }
}

/// setInt set int value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setInt('k',1);
///
Future<bool> setInt(String key, int value) async {
  assert(key.length > 0);
  '$_here|set $NOUN$key=$value'.print;
  var result = (await (await _get()).setInt(key, value));
  if (!result) {
    eventBus.broadcast(EDiskFullOrNoAccess());
  }
}

/// setDouble set double value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setDouble('k',1);
///
Future<void> setDouble(String key, double value) async {
  assert(key.length > 0);
  '$_here|set $NOUN$key=$value'.print;
  var result = (await (await _get()).setDouble(key, value));
  if (!result) {
    eventBus.broadcast(EDiskFullOrNoAccess());
  }
}

/// setString set string value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setString('k','value');
///
Future<void> setString(String key, String value) async {
  assert(key.length > 0);
  '$_here|set $NOUN$key=$value'.print;
  var result = (await (await _get()).setString(key, value));
  if (!result) {
    eventBus.broadcast(EDiskFullOrNoAccess());
  }
}

/// setStringList set string list to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setStringList('k',list);
///
Future<bool> setStringList(String key, List<String> value) async {
  assert(key.length > 0);
  '$_here|set $NOUN$key=$value'.print;
  var result = (await (await _get()).setStringList(key, value));
  if (!result) {
    eventBus.broadcast(EDiskFullOrNoAccess());
  }
}

/// setMap set string map to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setMap('k',map);
///
Future<void> setMap(String key, Map<String, dynamic> map) async {
  // String json = JsonEncoder.withIndent('').convert(map);
  String j = json.encode(map);
  return await setString(key, j);
}

/// mockInit Initializes the value for testing
///
///     data.mockInit({});
///
@visibleForTesting
void mockInit(Map<String, dynamic> values) {
  SharedPreferences.setMockInitialValues(values);
}
