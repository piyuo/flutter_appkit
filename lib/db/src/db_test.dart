// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'db.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[db]', () {
    test('should init', () async {
      await initDBForTest();
      final database = await openDatabase('test');
      await database.setString('a', 'b');
      expect(database.contains('a'), true);
      await database.close();

      // open again
      final database2 = await openDatabase('test');
      await database2.setString('b', 'c');
      expect(database2.contains('a'), true);
      expect(database2.contains('b'), true);
      await deleteDatabase('test');

      // since it's been deleted, this should be a new database
      final database3 = await openDatabase('test');
      expect(database3.contains('a'), false);
      expect(database3.contains('b'), false);
      await deleteDatabase('test');
    });

    test('should open/delete database', () async {
      await initDBForTest();
      await openDatabase('test');
      expect(await isDatabaseExists('test'), true);
      await deleteDatabase('test');
      expect(await isDatabaseExists('test'), false);
    });
  });
}
