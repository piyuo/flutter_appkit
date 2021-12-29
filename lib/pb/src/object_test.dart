import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/src/simple/simple.dart' as simple;
import 'dart:convert';

void main() {
  group('[object]', () {
    test('should return JSON', () {
      final obj = simple.Error()..code = 'hi';
      expect(obj.jsonString, isNotEmpty);
    });

    test('should write/read json', () {
      final obj = simple.Error()..code = 'hi';
      final jText = obj.toJson();
      expect(jText, isNotEmpty);

      final jsonMap = json.decode(jText) as Map<String, dynamic>;
      final obj2 = simple.Error()..fromJsonMap(jsonMap);
      expect(obj2.code, 'hi');
    });

    test('should write/read base64 string', () {
      final obj = simple.Error()..code = 'hi';
      final str = obj.toBase64();
      expect(str, isNotEmpty);

      final obj2 = simple.Error()..fromBase64(str);
      expect(obj2.code, 'hi');
    });
  });
}
