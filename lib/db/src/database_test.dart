// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:flutter_test/flutter_test.dart';
import 'database.dart';
import 'db.dart';

void main() {
  setUpAll(() async {
    await initForTest('test');
  });

  setUp(() async {});

  group('[database]', () {
    test('should set/get int', () async {
      final database = Database();
      await database.open('test');
      await database.setInt('k', 1);
      final value = database.getInt('k');
      expect(value, 1);
    });

    test('should set/get string', () async {
      final database = Database();
      await database.open('test');
      await database.setString('k', 'hi');
      final value = database.getString('k');
      expect(value, 'hi');
    });

    test('should set/get datetime', () async {
      final database = Database();
      await database.open('test');
      final now = DateTime.now();
      await database.setDateTime('k', now);
      final value = database.getDateTime('k');
      expect(value, now);
    });

    test('should set/get pb.object', () async {
      final database = Database();
      await database.open('test');
      final person = sample.Person(name: 'l');
      await database.setObject('k', person);
      final value = database.getObject<sample.Person>('k', () => sample.Person());
      expect(value, isNotNull);
      expect(value!.name, 'l');
      expect(value, person);
    });

    test('should save string list', () async {
      final database = Database();
      await database.open('test');
      final list = <String>['1', '2', '3'];
      await database.setStringList('l', list);
      var list2 = database.getStringList('l');
      expect(list2.length, 3);
      expect(list2[2], '3');
    });

    test('should save int list', () async {
      final database = Database();
      await database.open('test');
      final list = <int>[1, 2, 3];
      await database.setIntList('l', list);
      var list2 = database.getIntList('l');
      expect(list2.length, 3);
      expect(list2[2], 3);
    });

    test('should reset', () async {
      final database = Database();
      await database.open('test');
      await database.setString('a', 'b');
      await database.setString('1', '2');
      await database.reset();
      expect(database.contains('a'), false);
      expect(database.contains('1'), false);
    });
  });
}
