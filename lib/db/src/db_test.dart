// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:libcli/pb/pb.dart' as pb;

import 'package:flutter_test/flutter_test.dart';
import 'db.dart';

void main() {
  initForTest();
  registerBuilder((id, bytes) {
    return pb.Error.fromBuffer(bytes);
  });

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

    test('should put/get pb.object', () async {
      final testDB = await use('testDB');
      testDB.set('e', pb.Error()..code = '123');
      var err = await testDB.get('e');
      expect(err.code, '123');
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
