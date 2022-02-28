// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:flutter_test/flutter_test.dart';
import 'cache.dart';
import 'db.dart';

void main() {
  setUpAll(() async {
    await initDBForTest();
  });

  group('[cache]', () {
    test('should open/delete cache', () async {
      final cache = await openCache('cache_test', 'cache_test_time');
      await cache.setString('k', 'hello');
      await deleteCache('cache_test', 'cache_test_time');
    });

    test('should set/get', () async {
      final cache = await openCache('cache_test', 'cache_test_time');
      try {
        expect(cache.contains('k'), false);
        await cache.setBool('k', true);
        expect(cache.getBool('k'), true);
        expect(cache.contains('k'), true);
        await cache.setInt('k', 9);
        expect(cache.getInt('k'), 9);
        DateTime date = DateTime.utc(1989, 11, 9);
        await cache.setDateTime('k', date);
        expect(cache.getDateTime('k'), date);
        await cache.setObject('k', sample.Person(name: 'john'));
        expect(cache.getObject<sample.Person>('k', () => sample.Person())!.name, 'john');
        await cache.setString('k', 'a');
        expect(cache.getString('k'), 'a');
        await cache.setStringList('k', ['a', 'b']);
        final list = cache.getStringList('k');
        expect(list![0], 'a');
        expect(list[1], 'b');
        await cache.setIntList('k', [1, 2]);
        final intList = cache.getIntList('k');
        expect(intList![0], 1);
        expect(intList[1], 2);
      } finally {
        await deleteCache('cache_test', 'cache_test_time');
      }
    });

    test('should cache data', () async {
      final cache = await openCache('cache_test', 'cache_test_time');
      try {
        expect(cache.length, 0);
        expect(cache.timeLength, 0);
        expect(cache.setCount, 0);
        await cache.setString('hello', 'world');
        var name = cache.getString('hello');
        expect(name, 'world');
        expect(cache.length, 2);
        expect(cache.timeLength, 1);
        expect(cache.setCount, 1);
        await cache.reset();
        expect(cache.length, 0);
        expect(cache.timeLength, 0);
        expect(cache.setCount, 0);
      } finally {
        await deleteCache('cache_test', 'cache_test_time');
      }
    });

    test('should reuse time tag', () async {
      final cache = await openCache('cache_test', 'cache_test_time');
      try {
        await cache.setString('hello', 'world');
        expect(cache.tagKey('hello'), 'hello_tag');
        final savedTag = cache.getSavedTag('hello');
        expect(savedTag, isNotNull);

        await cache.setString('hello', 'world');
        final savedTag2 = cache.getSavedTag('hello');
        expect(savedTag, savedTag2);
      } finally {
        await deleteCache('cache_test', 'cache_test_time');
      }
    });

    test('should delete from cache', () async {
      final cache = await openCache('cache_test', 'cache_test_time');
      try {
        await cache.setString('hello', 'world');
        expect(cache.length, 2);
        expect(cache.timeLength, 1);

        await cache.delete('hello');
        expect(cache.length, 0);
        expect(cache.timeLength, 0);
      } finally {
        await deleteCache('cache_test', 'cache_test_time');
      }
    });

    test('should cleanup', () async {
      final cache = await openCache('cache_test', 'cache_test_time');
      try {
        final expired = DateTime.now().add(const Duration(days: -366)).millisecondsSinceEpoch;
        final expiredTag = expired.toString();
        await cache.setTestString(expiredTag, 'expired', 'hello');
        expect(cache.getString('expired'), 'hello');

        final notExpired = DateTime.now().add(const Duration(days: -364)).millisecondsSinceEpoch;
        final notExpiredTag = notExpired.toString();
        await cache.setTestString(notExpiredTag, 'notExpired', 'world');
        expect(cache.getString('notExpired'), 'world');

        expect(cache.length, 4);
        expect(cache.timeLength, 2);
        await cache.cleanup();
        expect(cache.length, 2);
        expect(cache.timeLength, 1);

        expect(cache.getString('expired'), isNull);
        expect(cache.getString('notExpired'), 'world');
      } finally {
        await deleteCache('cache_test', 'cache_test_time');
      }
    });

    test('should run cleanup when setCount > cleanupWhenSet', () async {
      final cache = await openCache('cache_test', 'cache_test_time');
      try {
        for (int i = 0; i < cleanupWhenSet; i++) {
          await cache.setString('hello_$i', 'world');
        }
        expect(cache.setCount, cleanupWhenSet);
        await cache.setString('hello_10', 'world');
        expect(cache.setCount, 0);
      } finally {
        await deleteCache('cache_test', 'cache_test_time');
      }
    });
  });
}
