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
