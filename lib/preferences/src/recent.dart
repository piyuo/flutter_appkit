import 'preferences.dart';

/// _maxRecentHistory is max length of recent history
const _maxRecentHistory = 60;

/// _maxRecentShow is max length of recent to show
const _maxRecentShow = 6;

/// addRecent add recent value to preferences
/// ```dart
/// await preferences.addRecent('k','text1');
/// ```
Future<void> addRecent(String key, String value, {int maxLength = _maxRecentHistory}) async {
  assert(key.isNotEmpty);
  value = value.trim();
  if (value.isEmpty) {
    return;
  }
  var history = (await getStringList(key)) ?? <String>[];
  history.removeWhere((String s) => s == value);
  history.insert(0, value);
  if (history.length > maxLength) {
    history.removeLast();
  }
  await setStringList(key, history);
}

/// getRecent return list from preferences
/// ```dart
/// var result = await preferences.getRecent('k');
/// ```
Future<List<String>> getRecent(String key, {String input = '', int maxLength = _maxRecentShow}) async {
  final history = await getStringList(key) ?? <String>[];
  if (input.isNotEmpty) {
    history.removeWhere((String s) => !s.contains(input));
  }
  return history.sublist(0, history.length > maxLength ? maxLength : history.length);
}
