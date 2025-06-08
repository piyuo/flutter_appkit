// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'db.dart';

void main() {
  setUpAll(() async {
    await initForTest();
    await deleteTestDb('test_db');
  });

  setUp(() async {});

  tearDownAll(() async {
    await deleteTestDb('test_db');
  });

  group('[db]', () {
    test('should reset', () async {
      final database = await open('test_db');
      await database.setString('a', 'b');
      expect(database.contains('a'), true);
    });
  });
}
