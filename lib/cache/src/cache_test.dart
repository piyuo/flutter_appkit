// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:libcli/db/db.dart' as db;
import 'package:flutter_test/flutter_test.dart';
import 'cache.dart';

void main() {
  db.initForTest();
  init();

  setUp(() async {});

  tearDownAll(() async {
    await reset();
  });

  group('[cache]', () {
    test('should cache data', () async {
      expect(length, 0);
      expect(timeLength, 0);
      expect(setCount, 0);
      await set('hello', 'world');
      var name = await get('hello');
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
      await set('hello', 'world');
      expect(tagKey('hello'), 'hello_tag');
      final savedTag = await getSavedTag('hello');
      expect(savedTag, isNotNull);

      await set('hello', 'world');
      final savedTag2 = await getSavedTag('hello');
      expect(savedTag, savedTag2);
    });

    test('should support namespace', () async {
      await reset();
      await set('hello', 'world', namespace: 'my');
      expect(length, 2);
      expect(timeLength, 1);

      var value = await get('hello');
      expect(value, isNull);

      value = await get('hello', namespace: 'my');
      expect(value, 'world');

      await delete('hello', namespace: 'my');
      value = await get('hello', namespace: 'my');
      expect(value, isNull);
    });

    test('should delete from cache', () async {
      await reset();
      await set('hello', 'world');
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
      await setTestItem(expiredTag, 'expired', 'hello');
      expect(await get('expired'), 'hello');

      final notExpired = DateTime.now().add(const Duration(days: -364)).millisecondsSinceEpoch;
      final notExpiredTag = notExpired.toString();
      await setTestItem(notExpiredTag, 'notExpired', 'world');
      expect(await get('notExpired'), 'world');

      expect(length, 4);
      expect(timeLength, 2);
      await cleanup();
      expect(length, 2);
      expect(timeLength, 1);

      expect(await get('expired'), isNull);
      expect(await get('notExpired'), 'world');
    });

    test('should run cleanup when setCount > 10', () async {
      for (int i = 0; i < 10; i++) {
        await set('hello_$i', 'world');
      }
      expect(setCount, 10);
      await set('hello_10', 'world');
      expect(setCount, 0);
    });
  });
}
