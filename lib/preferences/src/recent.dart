import 'package:flutter/widgets.dart';
import 'preferences.dart';

/// addRecent add recent value to preferences
/// ```dart
/// await preferences.addRecent('k','text1');
/// ```
Future<void> addRecent(String key, String value, {int maxLength = 10}) async {
  assert(key.isNotEmpty);
  debugPrint('[preferences] add recent $key=$value');

  var list = (await getStringList(key)) ?? <String>[];
  list.removeWhere((String s) => s == value);
  list.insert(0, value);
  if (list.length > maxLength) {
    list.removeLast();
  }
  await setStringList(key, list);
}

/// getRecent return list from preferences
/// ```dart
/// var result = await preferences.getRecent('k');
/// ```
Future<List<String>> getRecent(String key) async => await getStringList(key) ?? <String>[];
