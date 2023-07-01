import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/pb/src/common/common.dart' as common;
import 'timestamp.dart';

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
        t: DateTime(2023, 6, 15).timestamp,
        d: true,
      ));
      expect(person.id, '1');
      expect(person.timestamp.toDateTime(), DateTime(2023, 06, 15).toUtc());
      expect(person.utcTime.isAtSameMomentAs(DateTime(2023, 06, 15).toUtc()), true);
      expect(person.deleted, true);

      final person2 = sample.Person(
          m: common.Model(
        i: '2',
        t: DateTime(2023, 6, 16).timestamp,
        d: false,
      ));
      expect(person2.id, '2');
      expect(person2.timestamp.toDateTime(), DateTime(2023, 06, 16).toUtc());
      expect(person2.utcTime.isAtSameMomentAs(DateTime(2023, 06, 16).toUtc()), true);
      expect(person2.deleted, false);
    });

    test('should write/read base64 string', () {
      final obj = sample.Person(name: 'p1');
      final str = obj.toBase64();
      expect(str, isNotEmpty);

      final obj2 = sample.Person()..fromBase64(str);
      expect(obj2.name, 'p1');
    });

    test('should write to searchable string', () {
      final obj = sample.Person(name: 'p1', age: 49, stringValue: 'Eye Color: Blue');
      final str = obj.toString().toLowerCase();
      expect(str.contains('p1'), isTrue);
      expect(str.contains('blue'), isTrue);
      expect(str.contains('notExists'), isFalse);
    });

    test('should comparable', () {
      final obj = sample.Person(name: 'p1');
      final obj2 = sample.Person(name: 'p2');
      final obj3 = sample.Person(name: 'p1');
      expect(obj != obj2, true);
      expect(obj == obj3, true);

      final buf = obj.writeToBuffer();
      final buf2 = obj2.writeToBuffer();
      final buf3 = obj3.writeToBuffer();
      expect(listEquals(buf, buf2), false);
      expect(listEquals(buf, buf3), true);
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

    test('should update time', () {
      final initTime = DateTime(2023, 6, 15);
      final person = sample.Person(
          m: common.Model(
        i: '1',
        t: initTime.timestamp,
        d: false,
      ));

      person.deleted = true;
      expect(person.utcTime.isAfter(initTime.toUtc()), isTrue);
      expect(person.deleted, isTrue);
    });
  });
}
