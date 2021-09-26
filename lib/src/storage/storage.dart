import 'package:localstorage/localstorage.dart';

final _storage = LocalStorage('app.json');

Future<void> setItem(String key, Map<String, dynamic> value) async {
  await _storage.setItem(key, value);
}

Future<Map<String, dynamic>?> getItem(String key) async {
  return await _storage.getItem(key);
}

Future<void> delete(String key) async {
  await _storage.deleteItem(key);
}

Future<void> clear() async {
  await _storage.clear();
}
