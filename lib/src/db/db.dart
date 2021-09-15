import 'storage.dart';

final Storage _storage = Storage('db.json');

Future<void> set(String key, Map<String, dynamic> value) async {
  _storage.set(key, value);
}

Future<Map<String, dynamic>?> get(String key) async {
  return _storage.get(key);
}

Future<void> delete(String key) async {
  _storage.delete(key);
}

Future<void> clear() async {
  _storage.clear();
}
