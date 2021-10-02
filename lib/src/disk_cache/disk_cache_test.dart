// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/storage.dart' as storage;
import 'disk_cache.dart';
import 'registry.dart';

void main() {
  setUp(() {
    storage.clear();
    mockRegistries = null;
  });

  group('[registries]', () {
    test('should return cached size', () {
      DateTime date = DateTime.now().add(const Duration(days: 1)).toUtc();
      mockRegistries = [];
      expect(cachedSize(), 0);

      mockRegistries = [
        Registry(key: '1', size: 2, expired: date),
        Registry(key: '2', size: 4, expired: date),
        Registry(key: '3', size: 8, expired: date),
      ];
      expect(cachedSize(), 14);
    });

    test('should delete from cache', () async {
      final result = await add('1', {'k': 'v'}, expire: const Duration(days: 1));
      expect(result, isNotNull);
      expect(await containsRegistryKey('1'), true);
      final r = registryByKey('1');
      final j = await cachedItem(r!);
      expect(j, isNotNull);
      expect(j!['k'], 'v');
      expect(r, isNotNull);
      await deleteRegistry(r);
      expect(await containsRegistryKey('1'), false);
      expect(registryByKey('1'), isNull);
    });

    test('should remove oldest registry and cache item', () async {
      final r1 = await add('1', {'k1': 'v1'});
      final r2 = await add('2', {'k2': 'v2'});
      final r3 = await add('3', {'k3': 'v3'});
      expect((await cachedItem(r1!))!['k1'], 'v1');
      expect((await cachedItem(r2!))!['k2'], 'v2');
      expect((await cachedItem(r3!))!['k3'], 'v3');
      expect(await removeOldest(), true);
      expect(mockRegistries[0].key, '2');
      expect(await removeOldest(), true);
      expect(mockRegistries[0].key, '3');
      expect(await removeOldest(), true);
      expect(mockRegistries.isEmpty, true);
      expect(await removeOldest(), false);
    });

    test('should prepare space', () async {
      final r1 = await add('1', {'k': 'v'});
      expect(await cachedItem(r1!), isNotNull);
      expect(await containsRegistryKey(r1.key), true);

      var result = await prepareSpace(maxCachedSize - 1);
      expect(result, true);
      expect(await cachedItem(r1), isNull);
      expect(await containsRegistryKey(r1.key), false);
    });

    test('should clean expired', () async {
      final r1 = await add('1', {'k1': 'v1'}, expire: const Duration(days: -1));
      expect(await cachedItem(r1!), isNotNull);
      expect(await containsRegistryKey(r1.key), true);

      final r2 = await add('2', {'k2': 'v2'}, expire: const Duration(days: 1));
      expect(await cachedItem(r2!), isNotNull);
      expect(await containsRegistryKey(r2.key), true);

      final r3 = await add('3', {'k3': 'v3'}, expire: const Duration(days: -1));
      expect(await cachedItem(r3!), isNotNull);
      expect(await containsRegistryKey(r3.key), true);

      cleanExpired();
      expect(await cachedItem(r1), isNull);
      expect(await containsRegistryKey(r1.key), false);
      expect(await cachedItem(r2), isNotNull);
      expect(await containsRegistryKey(r2.key), true);
      expect(await cachedItem(r3), isNull);
      expect(await containsRegistryKey(r3.key), false);
      expect(mockRegistries.length, 1);
    });

    test('should save to cache and read from cache', () async {
      final result = await add('1', {'k': 'v'}, expire: const Duration(days: 1));
      expect(result, isNotNull);
      mockRegistries = null;

      final list = await get('1');
      expect(list, isNotNull);
      expect(list!['k'], 'v');
    });

    test('should update cache width new one', () async {
      final result = await add('1', {'k': 'v'}, expire: const Duration(days: 1));
      expect(result, isNotNull);
      final result2 = await add('2', {'k2': 'v2'}, expire: const Duration(days: 1));
      expect(result2, isNotNull);
      final result3 = await add('1', {'k': 'v'}, expire: const Duration(days: 1));
      expect(result3, isNotNull);

      expect(mockRegistries.length, 2);
      expect(mockRegistries[0].key, '2');
      expect((await cachedItem(result2!))!['k2'], 'v2');
      expect(mockRegistries[1].key, '1');
      expect((await cachedItem(result3!))!['k'], 'v');
    });

    test('should cache fast', () async {
      for (var i = 0; i < 100; i++) {
        final result = await add('$i', {'$i': '$i'}, expire: const Duration(days: 1));
        expect(result, isNotNull);
      }
    });
  });
}
