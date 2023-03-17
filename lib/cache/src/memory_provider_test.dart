// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:libcli/sample/sample.dart' as sample;
import 'package:flutter_test/flutter_test.dart';
import 'memory_provider.dart';

void main() {
  group('[cache.memory_provider]', () {
    test('should set/get', () async {
      final memoryProvider = MemoryProvider(cacheDBName: 'test_set_cache', timeDBName: 'test_set_time');
      await memoryProvider.init();
      expect(memoryProvider.containsKey('k'), false);
      await memoryProvider.put('k', true);
      expect(await memoryProvider.get('k'), true);
      expect(memoryProvider.containsKey('k'), true);
      await memoryProvider.put('k', 9);
      expect(await memoryProvider.get('k'), 9);
      DateTime date = DateTime.utc(1989, 11, 9);
      await memoryProvider.put('k', date);
      expect(await memoryProvider.get('k'), date);
      await memoryProvider.putObject('k', sample.Person(name: 'john'));
      expect((await memoryProvider.getObject<sample.Person>('k', () => sample.Person()))!.name, 'john');
      await memoryProvider.put('k', 'a');
      expect(await memoryProvider.get('k'), 'a');
      await memoryProvider.put('k', ['a', 'b']);
      final list = await memoryProvider.get<List>('k');
      expect(list![0], 'a');
      expect(list[1], 'b');
      await memoryProvider.put('k', [1, 2]);
      final intList = await memoryProvider.get('k');
      expect(intList![0], 1);
      expect(intList[1], 2);
      await memoryProvider.removeBox();
    });
    test('should cache data', () async {
      final memoryProvider = MemoryProvider(cacheDBName: 'test_data_cache', timeDBName: 'test_data_time');
      await memoryProvider.init();
      expect(memoryProvider.length, 0);
      expect(memoryProvider.timeLength, 0);
      await memoryProvider.put('hello', 'world');
      var name = await memoryProvider.get('hello');
      expect(name, 'world');
      expect(memoryProvider.length, 2);
      expect(memoryProvider.timeLength, 1);
      await memoryProvider.reset();
      expect(memoryProvider.length, 0);
      expect(memoryProvider.timeLength, 0);
      await memoryProvider.removeBox();
    });

    test('should reuse time tag', () async {
      final memoryProvider = MemoryProvider(cacheDBName: 'test_reuse_cache', timeDBName: 'test_reuse_time');
      await memoryProvider.init();
      await memoryProvider.put('hello', 'world');
      expect(memoryProvider.tagKey('hello'), 'hello_tag');
      final savedTag = await memoryProvider.getSavedTag('hello');
      expect(savedTag, isNotNull);

      await memoryProvider.put('hello', 'world');
      final savedTag2 = await memoryProvider.getSavedTag('hello');
      expect(savedTag, savedTag2);
      await memoryProvider.removeBox();
    });

    test('should delete from cache', () async {
      final memoryProvider = MemoryProvider(cacheDBName: 'test_delete_cache', timeDBName: 'test_delete_time');
      await memoryProvider.init();
      await memoryProvider.put('hello', 'world');
      expect(memoryProvider.length, 2);
      expect(memoryProvider.timeLength, 1);

      await memoryProvider.delete('hello');
      expect(memoryProvider.length, 0);
      expect(memoryProvider.timeLength, 0);
      await memoryProvider.removeBox();
    });

    test('should compact', () async {
      final memoryProvider = MemoryProvider(cacheDBName: 'test_compact_cache', timeDBName: 'test_compact_time');
      await memoryProvider.init();
      final expired = DateTime.now().add(const Duration(days: -366)).millisecondsSinceEpoch;
      final expiredTag = expired.toString();
      await memoryProvider.setTestString(expiredTag, 'expired', 'hello');
      expect(await memoryProvider.get('expired'), 'hello');

      final notExpired = DateTime.now().add(const Duration(days: -364)).millisecondsSinceEpoch;
      final notExpiredTag = notExpired.toString();
      await memoryProvider.setTestString(notExpiredTag, 'notExpired', 'world');
      expect(await memoryProvider.get('notExpired'), 'world');

      expect(memoryProvider.length, 4);
      expect(memoryProvider.timeLength, 2);
      await memoryProvider.compact();
      expect(memoryProvider.length, 2);
      expect(memoryProvider.timeLength, 1);

      expect(await memoryProvider.get('expired'), isNull);
      expect(await memoryProvider.get('notExpired'), 'world');
      await memoryProvider.removeBox();
    });
  });
}
