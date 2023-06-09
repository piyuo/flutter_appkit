import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/src/common/common.dart' as common;
import 'package:libcli/sample/sample.dart' as sample;
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

    test('should have model', () {
      final person = sample.Person();
      expect(person.hasModel, isTrue);
      expect(person.id, isNotEmpty);
      expect(person.timestamp, isNotNull);
    });

    test('should get/set field by name', () {
      final person = sample.Person();
      person.name = 'ian';
      person.age = 4;
      expect(person.isFieldExists('notExists'), isFalse);
      expect(person.isFieldExists('name'), isTrue);
      expect(person['notExists'], isNull);
      expect(person['name'], 'ian');
      expect(person['age'], 4);

      person['name'] = 'iris';
      person['age'] = 3;
      expect(person.name, 'iris');
      expect(person.age, 3);
    });
  });
}
