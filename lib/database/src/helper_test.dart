// ignore_for_file: invalid_use_of_visible_for_testing_member
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
    test('should open and delete', () async {
      final db = await open('test_db');
      await db.setBool('k', true);
      expect(await isExists('test_db'), true);

      await delete('test_db');
      expect(await isExists('test_db'), false);
    });
  });
}
