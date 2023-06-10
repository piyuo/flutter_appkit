import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/pb/src/common/common.dart' as common;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/google/google.dart' as google;
import 'dart:convert';

void main() {
  group('[pb.object]', () {
    test('should return JSON', () {
      final obj = sample.Person(name: 'p1');
      expect(obj.jsonString, isNotEmpty);
    });

    test('should write/read json', () {
      final obj = sample.Person(name: 'p1');
      final jText = obj.writeToJson();
      expect(jText, isNotEmpty);

      final jsonMap = json.decode(jText) as Map<String, dynamic>;
      final obj2 = sample.Person()..mergeFromJsonMap(jsonMap);
      expect(obj2.name, 'p1');
    });

    test('should return id, timestamp, time, deleted', () {
      final person = sample.Person(
          m: common.Model(
        i: '1',
        t: DateTime(2023, 6, 15).utcTimestamp,
        d: true,
      ));
      expect(person.utcTime.isAtSameMomentAs(DateTime(2023, 06, 15).toUtc()), true);
    });

    test('should write/read base64 string', () {
      final obj = sample.Person(name: 'p1');
      final str = obj.toBase64();
      expect(str, isNotEmpty);

      final obj2 = sample.Person()..fromBase64(str);
      expect(obj2.name, 'p1');
    });

    test('should comparable', () {
      final obj = sample.Person(name: 'p1');
      final obj2 = sample.Person(name: 'p2');
      final obj3 = sample.Person(name: 'p3');
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
