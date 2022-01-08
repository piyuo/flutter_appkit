import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/pb/pb.dart' as pb;

/// _storage can only support 1 operation at the same time, be careful with async function
final _storage = LocalStorage('app.json');

/// set save pb.object to local storage
///
///     await set('item1', sample);
///
Future<void> set(String key, pb.Object obj) async {
  log.debug('[storage set] $key');
  await _storage.setItem(key, obj.writeToJsonMap());
}

/// getJSON return json object from storage
///
///     final item1 = await get('item1');
///
Future<T?> get<T extends pb.Object>(String key, pb.Builder<T> builder) async {
  final map = await _storage.getItem(key);
  if (map != null) {
    T item = builder();
    item.fromJsonMap(map);
    return item;
  }
  return null;
}

/// delete a cache item from local storage
///
///     await delete('item1');
///
Future<void> delete(String key) async {
  log.debug('[storage] delete $key');
  await _storage.deleteItem(key);
}

/// setJSON save json object to local storage
///
///     await setJSON('item1', {'cleaning': 'done'});
///
Future<void> setJSON(String key, Map<String, dynamic> value) async {
  log.debug('[storage] set json $key');
  await _storage.setItem(key, value);
}

/// getJSON return json object from storage
///
///     final item1 = await getJSON('item1');
///
Future<Map<String, dynamic>?> getJSON(String key) async {
  return await _storage.getItem(key);
}

/// clear entire local storage
///
///     await clear();
///
@visibleForTesting
Future<void> clear() async {
  log.debug('[storage] clear');
  await _storage.clear();
}
