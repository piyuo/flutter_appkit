import 'package:localstorage/localstorage.dart';
import 'package:libcli/log.dart' as log;

final _storage = LocalStorage('app.json');

/// setStringList save string list to local storage
///
///     await setStringList('item1', ['cleaning', 'done']});
///
Future<void> setStringList(String key, List<String> value) async {
  log.debug('storage set list $key');
  await _storage.setItem(key, {'l': value});
}

/// getStringList return string list from storage
///
///     final list = await getStringList('item1');
///
Future<List<String>?> getStringList(String key) async {
  final record = await _storage.getItem(key);
  if (record != null) {
    return record['l'];
  }
  return record;
}

/// setJSON save json object to local storage
///
///     await setJSON('item1', {'cleaning': 'done'});
///
Future<void> setJSON(String key, Map<String, dynamic> value) async {
  log.debug('storage set json $key');
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
  log.debug('storage set  $key $value');
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
  log.debug('storage delete $key');
  await _storage.deleteItem(key);
}

/// clear entire local storage
///
///     await clear();
///
Future<void> clear() async {
  log.debug('storage clear');
  await _storage.clear();
}
