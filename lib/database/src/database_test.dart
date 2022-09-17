// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:libcli/sample/sample.dart' as sample;
import 'package:flutter_test/flutter_test.dart';
import 'base.dart';
import 'helper.dart';

void main() {
  setUpAll(() async {
    await initForTest();
    await delete('test_db');
  });

  setUp(() async {});

  tearDown(() async {
    await delete('test_db');
  });

  group('[database]', () {
    test('should delete', () async {
      final database = await open('test_delete');
      await database.setBool('k', true);
      expect(database.contains('k'), true);
      await database.delete('k');
      expect(database.contains('k'), false);
      await delete('test_delete');
    });

    test('should set/get bool', () async {
      final database = await open('test_bool');
      await database.setBool('k', false);
      final value = await database.getBool('k');
      expect(value, false);
      await delete('test_bool');
    });

    test('should set/get map', () async {
      final database = await open('test_int');
      await database.setMap('k', {
        'a': 1,
        'b': ['x', 'y']
      });
      final value = await database.getMap('k');
      expect(value!['a'], 1);
      expect(value['b'][0], 'x');
      expect(value['b'][1], 'y');
      await delete('test_int');
    });

    test('should set/get int', () async {
      final database = await open('test_int');
      await database.setInt('k', 1);
      final value = await database.getInt('k');
      expect(value, 1);
      await delete('test_int');
    });

    test('should set/get string', () async {
      final database = await open('test_string');
      await database.setString('k', 'hi');
      final value = await database.getString('k');
      expect(value, 'hi');
      await delete('test_string');
    });

    test('should set/get datetime', () async {
      final database = await open('test_datetime');
      final now = DateTime.now();
      await database.setDateTime('k', now);
      final value = await database.getDateTime('k');
      expect(now.year, value!.year);
      expect(now.month, value.month);
      expect(now.day, value.day);
      expect(now.hour, value.hour);
      expect(now.minute, value.minute);
      await delete('test_datetime');
    });

    test('should set/get pb.object', () async {
      final database = await open('test_object');
      final person = sample.Person(name: 'l');
      await database.setObject('k', person);
      final value = await database.getObject<sample.Person>('k', () => sample.Person());
      expect(value, isNotNull);
      expect(value!.name, 'l');
      expect(value, person);
      await delete('test_object');
    });

    test('should save string list', () async {
      final database = await open('test_string_list');
      final list = <String>['1', '2', '3'];
      await database.setStringList('l', list);
      var list2 = await database.getStringList('l');
      expect(list2!.length, 3);
      expect(list2[2], '3');
      await delete('test_string_list');
    });

    test('should save int list', () async {
      final database = await open('test_list');
      final list = <int>[1, 2, 3];
      await database.setIntList('l', list);
      var list2 = await database.getIntList('l');
      expect(list2!.length, 3);
      expect(list2[2], 3);
      await delete('test_list');
    });

    test('should reset', () async {
      final database = await open('test_reset');
      await database.setString('a', 'b');
      await database.setString('1', '2');
      await database.reset();
      expect(database.contains('a'), false);
      expect(database.contains('1'), false);
      await delete('test_reset');
    });
  });
}
