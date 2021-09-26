import 'package:localstorage/localstorage.dart';

final _storage = LocalStorage('app.json');
/*
Future<void> set(String key, Map<String, dynamic> value) async {
  String
  _storage.setItem(key, value);
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
*/