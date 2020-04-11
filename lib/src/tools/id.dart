import 'dart:convert';
import 'dart:math';

/// create uuid
///
///     String id = uuid();
String uuid() {
  final Random _random = Random.secure();
  var values = List<int>.generate(24, (i) => _random.nextInt(256));
  String text = base64Url.encode(values);
  return text.substring(0, text.length - 2);
}
