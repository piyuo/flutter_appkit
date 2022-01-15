import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/src/common/common.dart' as common;
import 'dart:convert';

void main() {
  group('[object]', () {
    test('should return JSON', () {
      final obj = common.Error()..code = 'hi';
      expect(obj.jsonString, isNotEmpty);
    });

    test('should write/read json', () {
      final obj = common.Error()..code = 'hi';
      final jText = obj.writeToJson();
      expect(jText, isNotEmpty);

      final jsonMap = json.decode(jText) as Map<String, dynamic>;
      final obj2 = common.Error()..mergeFromJsonMap(jsonMap);
      expect(obj2.code, 'hi');
    });

    test('should write/read base64 string', () {
      final obj = common.Error()..code = 'hi';
      final str = obj.toBase64();
      expect(str, isNotEmpty);

      final obj2 = common.Error()..fromBase64(str);
      expect(obj2.code, 'hi');
    });

    test('should comparable', () {
      final obj = common.Error()..code = 'hi';
      final obj2 = common.Error()..code = 'hi2';
      final obj3 = common.Error()..code = 'hi';
      expect(obj != obj2, true);
      expect(obj == obj3, true);

      final buf = obj.writeToBuffer();
      final buf2 = obj2.writeToBuffer();
      final buf3 = obj3.writeToBuffer();
      expect(listEquals(buf, buf2), false);
      expect(listEquals(buf, buf3), true);
    });
  });
}
