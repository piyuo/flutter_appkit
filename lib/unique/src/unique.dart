import 'dart:convert';
import 'dart:math';

/// _chars used by randomNumber
const _chars = '1234567890';

/// randomNumber generate random digit number string
/// ```dart
/// final id = randomNumber();
/// ```
String randomNumber(int digit) {
  final Random _random = Random.secure();
  return String.fromCharCodes(Iterable.generate(digit, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));
}

/// uuid create unique id
/// ```dart
/// final id = uuid();
/// ```
String uuid() => generate(24);

/// generate unique id
/// ```dart
/// final id = generate(8);
/// ```
String generate(int digit) {
  final Random _random = Random.secure();
  var values = List<int>.generate(digit, (i) => _random.nextInt(256));
  String text = base64Url.encode(values);
  return text.substring(0, text.length - 2);
}
