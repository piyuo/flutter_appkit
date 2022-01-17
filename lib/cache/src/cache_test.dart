// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:libcli/db/db.dart' as db;
import 'package:flutter_test/flutter_test.dart';
import 'cache.dart';

void main() {
  setUpAll(() async {
    await db.initForTest();
    await initForTest();
  });

  tearDownAll(() async {
    await cleanupTest();
  });

  setUp(() async {});

  group('[cache]', () {
    test('should cache data', () async {
      expect(length, 0);
      expect(timeLength, 0);
      expect(setCount, 0);
      await setString('hello', 'world');
      var name = getString('hello');
      expect(name, 'world');
      expect(length, 2);
      expect(timeLength, 1);
      expect(setCount, 1);
      await reset();
      expect(length, 0);
      expect(timeLength, 0);
      expect(setCount, 0);
    });

    test('should reuse time tag', () async {
      await reset();
      await setString('hello', 'world');
      expect(tagKey('hello'), 'hello_tag');
      final savedTag = getSavedTag('hello');
      expect(savedTag, isNotNull);

      await setString('hello', 'world');
      final savedTag2 = getSavedTag('hello');
      expect(savedTag, savedTag2);
    });

    test('should support namespace', () async {
      await reset();
      await setString('hello', 'world', namespace: 'my');
      expect(length, 2);
      expect(timeLength, 1);

      var value = getString('hello');
      expect(value, isNull);

      value = getString('hello', namespace: 'my');
      expect(value, 'world');

      await delete('hello', namespace: 'my');
      value = getString('hello', namespace: 'my');
      expect(value, isNull);
    });

    test('should delete from cache', () async {
      await reset();
      await setString('hello', 'world');
      expect(length, 2);
      expect(timeLength, 1);

      await delete('hello');
      expect(length, 0);
      expect(timeLength, 0);
    });

    test('should cleanup', () async {
      await reset();

      final expired = DateTime.now().add(const Duration(days: -366)).millisecondsSinceEpoch;
      final expiredTag = expired.toString();
      await setTestString(expiredTag, 'expired', 'hello');
      expect(getString('expired'), 'hello');

      final notExpired = DateTime.now().add(const Duration(days: -364)).millisecondsSinceEpoch;
      final notExpiredTag = notExpired.toString();
      await setTestString(notExpiredTag, 'notExpired', 'world');
      expect(getString('notExpired'), 'world');

      expect(length, 4);
      expect(timeLength, 2);
      await cleanup();
      expect(length, 2);
      expect(timeLength, 1);

      expect(getString('expired'), isNull);
      expect(getString('notExpired'), 'world');
    });

    test('should run cleanup when setCount > cleanupWhenSet', () async {
      for (int i = 0; i < cleanupWhenSet; i++) {
        await setString('hello_$i', 'world');
      }
      expect(setCount, cleanupWhenSet);
      await setString('hello_10', 'world');
      expect(setCount, 0);
    });
  });
}
