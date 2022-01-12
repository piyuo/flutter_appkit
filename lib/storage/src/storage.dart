import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/pb/pb.dart' as pb;

/// _expirationExt is for setStringWithExpiration, we need extra expiration time
const expirationExt = '_EXP';

/// initForTest Initializes the value for test
///
///     prefs.initForTest({});
///
@visibleForTesting
void initForTest(Map<String, Object> values) {
  // ignore:invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(values);
}

/// containsKey return true if key exists
///
///     bool found = await storage.containsKey('k');
///
Future<bool> containsKey(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.containsKey(key);
}

/// delete value from storage
///
///     var result = await storage.delete('k');
///
Future<bool> delete(String key) async {
  assert(key.isNotEmpty);
  log.log('[storage] remove $key');
  final instance = await SharedPreferences.getInstance();
  return await instance.remove(key);
}

/// getBool return boolean value from storage
///
///     var result = await storage.getBool('k');
///
Future<bool?> getBool(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.getBool(key);
}

/// setBool set boolean value to storage, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await storage.setBool('k',true);
///
Future<void> setBool(String key, bool value) async {
  assert(key.isNotEmpty);
  log.log('[storage] set $key=$value');
  final instance = await SharedPreferences.getInstance();
  var result = await instance.setBool(key, value);
  if (!result) {
    throw log.DiskErrorException();
  }
}

/// getInt return int value from storage
///
///     var result = await storage.getInt('k');
///
Future<int?> getInt(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.getInt(key);
}

/// setInt set int value to storage, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await storage.setInt('k',1);
///
Future<void> setInt(String key, int value) async {
  assert(key.isNotEmpty);
  log.log('[storage] set $key=$value');
  final instance = await SharedPreferences.getInstance();
  var result = await instance.setInt(key, value);
  if (!result) {
    throw log.DiskErrorException();
  }
}

/// getDouble return double value from storage
///
///     var result = await storage.getDouble('k');
///
Future<double?> getDouble(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.getDouble(key);
}

/// setDouble set double value to storage, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await storage.setDouble('k',1);
///
Future<void> setDouble(String key, double value) async {
  assert(key.isNotEmpty);
  log.log('[storage] set $key=$value');
  final instance = await SharedPreferences.getInstance();
  var result = await instance.setDouble(key, value);
  if (!result) {
    throw log.DiskErrorException();
  }
}

/// getString return string value from storage
///
///     var result = await storage.getString('k');
///
Future<String?> getString(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.getString(key);
}

/// setString set string value to storage, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await storage.setString('k','value');
///
Future<void> setString(String key, String value) async {
  assert(key.isNotEmpty);
  log.log('[storage] set $key=$value');
  final instance = await SharedPreferences.getInstance();
  var result = await instance.setString(key, value);
  if (!result) {
    throw log.DiskErrorException();
  }
}

/// getStringWithExp return string value from storage and check expiration date
///
///     final str = await storage.getStringWithExp('k');
///
Future<String?> getStringWithExp(String key) async {
  var exp = await getDateTime(key + expirationExt);
  if (exp != null) {
    final now = DateTime.now();
    if (exp.isBefore(now)) {
      //expired
      delete(key);
      delete(key + expirationExt);
      return null;
    }
  }
  return await getString(key);
}

/// setStringWithExp set string value to storage with a expiration date
///
///     await storage.setStringWithExp('k', 'a', exp);
///
Future<void> setStringWithExp(String key, String value, DateTime expire) async {
  await setDateTime(key + expirationExt, expire);
  await setString(key, value);
}

/// getDateTime return datetime value from storage. return 1970/01/01 Epoch if not exist
///
///     var result = await storage.getDateTime('k');
///
Future<DateTime?> getDateTime(String key) async {
  var value = await getString(key);
  if (value != null) {
    return DateTime.parse(value);
  }
  return null;
}

/// setDateTime set datetime value to storage, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await storage.setDateTime('k', DateTime.now());
///
setDateTime(String key, DateTime value) async {
  assert(key.isNotEmpty);
  String formatted = value.toString().substring(0, 19);
  return await setString(key, formatted);
}

/// getStringList return string list from storage
///
///     var result = await storage.getStringList('k');
///
Future<List<String>?> getStringList(String key) async {
  assert(key.isNotEmpty);
  final instance = await SharedPreferences.getInstance();
  return instance.getStringList(key);
}

/// setStringList set string list to storage, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await storage.setStringList('k',list);
///
setStringList(String key, List<String> value) async {
  assert(key.isNotEmpty);
  log.log('[storage] set $key=$value');
  final instance = await SharedPreferences.getInstance();
  var result = await instance.setStringList(key, value);
  if (!result) {
    throw log.DiskErrorException();
  }
}

/// getMap return map from storage
///
///     var result = await storage.getMap('k');
///
Future<Map<String, dynamic>?> getMap(String key) async {
  final j = await getString(key);
  if (j != null) {
    return jsonDecode(j);
  }
  return null;
}

/// setMap set string map to storage, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await storage.setMap('k',map);
///
Future<void> setMap(String key, Map<String, dynamic> map) async {
  String j = json.encode(map);
  return await setString(key, j);
}

/// getMapList return map list from storage
///
///     var result = await storage.getMapList('k');
///
Future<List<Map<String, dynamic>>?> getMapList(String key) async {
  var list = await getStringList(key);
  if (list != null) {
    return list.map((e) => json.decode(e) as Map<String, dynamic>).toList();
  }
  return null;
}

/// setMapList set string map list to storage, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await storage.setMapList('k',list);
///
Future<void> setMapList(String key, List<Map<String, dynamic>> mapList) async {
  List<String> list = mapList.map((e) => json.encode(e)).toList();
  return await setStringList(key, list);
}

/// set save pb.object to local storage
///
///     await storage.setObject('item1', sample);
///
Future<void> setObject(String key, pb.Object obj) async {
  await setString(key, obj.writeToJson());
}

/// getJSON return json object from storage
///
///     final item1 = await storage.get('item1');
///
Future<T?> getObject<T extends pb.Object>(String key, pb.Builder<T> builder) async {
  final str = await getString(key);
  if (str != null) {
    T item = builder();
    item.mergeFromJson(str);
    return item;
  }
  return null;
}

/// clear entire storage,return true if successfully
///
///     await storage.clear();
///
Future<bool> clear() async {
  final instance = await SharedPreferences.getInstance();
  return await instance.clear();
}
