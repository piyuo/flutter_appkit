// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'db.dart';

void main() {
  setUpAll(() async {
    await initForTest();
    await deleteTestDb('test');
  });

  setUp(() async {});

  group('[db]', () {
    test('should reset', () async {
      final database = await open('testDB');
      await database.setString('a', 'b');
      expect(database.contains('a'), true);
    });
  });
}
