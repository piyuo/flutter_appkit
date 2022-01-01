// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:flutter_test/flutter_test.dart';
import 'db.dart';

void main() {
  initForTest({'sample': sample.objectBuilder});

  setUp(() async {});

  tearDownAll(() async {
    final testDB = await use('testDB');
    await testDB.deleteFromDisk();
  });

  group('[db]', () {
    test('should put/get simple data type', () async {
      final testDB = await use('testDB');
      testDB.set('hello', 'world');
      var name = await testDB.get('hello');
      expect(name, 'world');
    });

    test('should set/get pb.object', () async {
      final testDB = await use('testDB');
      testDB.set('e', sample.Person(name: '123'));
      var person = await testDB.get('e');
      expect(person.name, '123');
    });

    test('should set/get common object', () async {
      final testDB = await use('testDB');
      testDB.set('e', pb.DatasetSnapshot(data: ['123', '456']));
      var snapshot = await testDB.get('e');
      expect(snapshot.data[0], '123');
      expect(snapshot.data[1], '456');
    });

    test('should save string list ', () async {
      final list = <String>['1', '2', '3'];
      final testDB = await use('testDB');
      testDB.set('l', list);
      var list2 = await testDB.get('l');
      expect(list2.length, 3);
      expect(list2[2], '3');
    });
  });
}
