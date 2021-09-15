import 'package:localstorage/localstorage.dart';

class Storage {
  /// Storage name like 'db.json'
  Storage(String name) {
    _storage = LocalStorage(name);
  }

  late LocalStorage _storage;

  void dispose() {
    _storage.dispose();
  }

  Future<void> set(String key, Map<String, dynamic> value) async {
    _storage.setItem(key, value);
  }

  Future<Map<String, dynamic>?> get(String key) async {
    return _storage.getItem(key);
  }

  Future<void> delete(String key) async {
    _storage.deleteItem(key);
  }

  Future<void> clear() async {
    _storage.clear();
  }
}
