import 'package:localstorage/localstorage.dart';

final _storage = LocalStorage('app.json');

/// setJSON save json object to local storage
///
///     await setJSON('item1', {'cleaning': 'done'});
///
Future<void> setJSON(String key, Map<String, dynamic> value) async {
  await _storage.setItem(key, value);
}

/// getJSON return json object from storage
///
///     final item1 = await getJSON('item1');
///
Future<Map<String, dynamic>?> getJSON(String key) async {
  return await _storage.getItem(key);
}

/// setString save string to local storage
///
///     await setString('item1', 'hi');
///
Future<void> setString(String key, String value) async {
  await _storage.setItem(key, {'s': value});
}

/// getString return string from local storage
///
///     var str1 = await getString('item1');
///
Future<String?> getString(String key) async {
  final record = await _storage.getItem(key);
  if (record != null) {
    return record['s'];
  }
  return record;
}

/// delete a cache item from local storage
///
///     await delete('item1');
///
Future<void> delete(String key) async {
  await _storage.deleteItem(key);
}

/// clear entire local storage
///
///     await clear();
///
Future<void> clear() async {
  await _storage.clear();
}
