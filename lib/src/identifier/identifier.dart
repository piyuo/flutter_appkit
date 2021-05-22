import 'dart:convert';
import 'dart:math';

/// create uuid
///
///     String id = uuid();
///
String uuid() {
  final Random _random = Random.secure();
  var values = List<int>.generate(24, (i) => _random.nextInt(256));
  String text = base64Url.encode(values);
  return text.substring(0, text.length - 2);
}

/// _chars used by randomNumber
const _chars = '1234567890';

/// randomNumber generate random number string
///
///     String id = uuid();
///
String randomNumber(int digit) {
  final Random _random = Random.secure();
  return String.fromCharCodes(Iterable.generate(digit, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));
}
