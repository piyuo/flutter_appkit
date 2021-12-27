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
      testDB.put('hello', 'world');
      var name = testDB.get('hello');
      expect(name, 'world');
    });

    test('should put/get pb.object', () async {
      final testDB = await use('testDB');
      testDB.put('e', pb.Error()..code = '123');
      var err = testDB.get('e');
      expect(err.code, '123');
    });
  });
}
