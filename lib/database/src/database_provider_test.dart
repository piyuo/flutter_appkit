// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'helper.dart';
import 'database_provider.dart';
import 'base.dart';

void main() {
  setUpAll(() async {
    resetDatabaseUsage();
    await initForTest();
    await delete('test_db');
    await delete('test2_db');
  });

  tearDown(() async {
    await delete('test_db');
    await delete('test2_db');
  });

  group('[database_provider]', () {
    test('should keep track database usage', () async {
      final provide = DatabaseProvider(
        name: 'test',
        databaseBuilder: (name) async => await open('test_db'),
      );
      await provide.use();
      expect(provide.name, 'test');
      expect(databaseUsageCount, 1);

      final provide2 = DatabaseProvider(
        name: 'test',
        databaseBuilder: (name) async => await open('test_db'),
      );
      await provide2.use();
      expect(provide.name, 'test');
      expect(databaseUsageCount, 2);

      provide.dispose();
      expect(databaseUsageCount, 1);
      provide2.dispose();
      expect(databaseUsageCount, 0);
    });
    test('should reset when database name changed', () async {
      final provide = DatabaseProvider(
        name: 'test',
        databaseBuilder: (name) async => await open('test_db'),
      );
      await provide.use();
      expect(provide.name, 'test');
      expect(databaseUsageCount, 1);

      final provide2 = DatabaseProvider(
        name: 'test2',
        databaseBuilder: (name) async => await open('test2_db'),
      );
      await provide2.use();
      expect(provide2.name, 'test2');
      expect(databaseUsageCount, 1);

      provide.dispose();
      expect(databaseUsageCount, 1);
      provide2.dispose();
      expect(databaseUsageCount, 0);
    });
  });
}
