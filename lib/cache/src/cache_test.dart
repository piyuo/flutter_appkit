// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:libcli/sample/sample.dart' as sample;
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/database/database.dart' as database;
import 'cache.dart' as cache;

void main() {
  setUpAll(() async {
    await database.initForTest();
    await cache.init();
    await cache.reset();
  });

  tearDown(() async {
    await cache.reset();
  });

  tearDownAll(() async {
    await cache.clean();
  });

  group('[cache]', () {
    test('should set/get', () async {
      expect(cache.contains('k'), false);
      await cache.setBool('k', true);
      expect(await cache.getBool('k'), true);
      expect(cache.contains('k'), true);
      await cache.setInt('k', 9);
      expect(await cache.getInt('k'), 9);
      DateTime date = DateTime.utc(1989, 11, 9);
      await cache.setDateTime('k', date);
      expect(await cache.getDateTime('k'), date);
      await cache.setObject('k', sample.Person(name: 'john'));
      expect((await cache.getObject<sample.Person>('k', () => sample.Person()))!.name, 'john');
      await cache.setString('k', 'a');
      expect(await cache.getString('k'), 'a');
      await cache.setStringList('k', ['a', 'b']);
      final list = await cache.getStringList('k');
      expect(list![0], 'a');
      expect(list[1], 'b');
      await cache.setIntList('k', [1, 2]);
      final intList = await cache.getIntList('k');
      expect(intList![0], 1);
      expect(intList[1], 2);
    });

    test('should cache data', () async {
      expect(cache.length, 0);
      expect(cache.timeLength, 0);
      await cache.setString('hello', 'world');
      var name = await cache.getString('hello');
      expect(name, 'world');
      expect(cache.length, 2);
      expect(cache.timeLength, 1);
      await cache.reset();
      expect(cache.length, 0);
      expect(cache.timeLength, 0);
    });

    test('should reuse time tag', () async {
      await cache.setString('hello', 'world');
      expect(cache.tagKey('hello'), 'hello_tag');
      final savedTag = await cache.getSavedTag('hello');
      expect(savedTag, isNotNull);

      await cache.setString('hello', 'world');
      final savedTag2 = await cache.getSavedTag('hello');
      expect(savedTag, savedTag2);
    });

    test('should delete from cache', () async {
      await cache.setString('hello', 'world');
      expect(cache.length, 2);
      expect(cache.timeLength, 1);

      await cache.delete('hello');
      expect(cache.length, 0);
      expect(cache.timeLength, 0);
    });

    test('should compact', () async {
      final expired = DateTime.now().add(const Duration(days: -366)).millisecondsSinceEpoch;
      final expiredTag = expired.toString();
      await cache.setTestString(expiredTag, 'expired', 'hello');
      expect(await cache.getString('expired'), 'hello');

      final notExpired = DateTime.now().add(const Duration(days: -364)).millisecondsSinceEpoch;
      final notExpiredTag = notExpired.toString();
      await cache.setTestString(notExpiredTag, 'notExpired', 'world');
      expect(await cache.getString('notExpired'), 'world');

      expect(cache.length, 4);
      expect(cache.timeLength, 2);
      await cache.compact();
      expect(cache.length, 2);
      expect(cache.timeLength, 1);

      expect(await cache.getString('expired'), isNull);
      expect(await cache.getString('notExpired'), 'world');
    });
  });
}
