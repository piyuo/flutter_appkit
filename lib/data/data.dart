import 'package:shared_preferences/shared_preferences.dart';

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
Future<bool> getBool(String key) async => (await _get()).getBool(key) ?? false;

/// getInt return int value from data
///
///     var result = await data.getInt('k');
///
Future<int> getInt(String key) async => (await _get()).getInt(key) ?? 0;

/// getDouble return double value from data
///
///     var result = await data.getDouble('k');
///
Future<double> getDouble(String key) async =>
    (await _get()).getDouble(key) ?? 0;

/// getString return string value from data
///
///     var result = await data.getString('k');
///
Future<String> getString(String key) async =>
    (await _get()).getString(key) ?? '';

/// getStringList return string list from data
///
///     var result = await data.getStringList('k');
///
Future<List<String>> getStringList(String key) async =>
    (await _get()).getStringList(key) ?? [];

/// setBool set boolean value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setBool('k');
///
Future<bool> setBool(String key, bool value) async =>
    (await _get()).setBool(key, value);

/// setInt set int value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setInt('k');
///
Future<bool> setInt(String key, int value) async =>
    (await _get()).setInt(key, value);

/// setDouble set double value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setDouble('k');
///
Future<bool> setDouble(String key, double value) async =>
    (await _get()).setDouble(key, value);

/// setString set string value to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setString('k');
///
Future<bool> setString(String key, String value) async =>
    (await _get()).setString(key, value);

/// setStringList set string list to data, If [value] is null, this is equivalent to calling [remove()] on the [key].
///
///     await data.setStringList('k');
///
Future<bool> setStringList(String key, List<String> value) async =>
    (await _get()).setStringList(key, value);
