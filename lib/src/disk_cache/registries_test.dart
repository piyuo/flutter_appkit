// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/storage.dart' as storage;
import 'registries.dart';
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
      final result = await saveToCache('1', ['b64'], const Duration(days: 1));
      expect(result, isNotNull);
      expect(await containsRegistryKey('1'), true);
      final r = registryByKey('1');
      final list = await cachedList(r!);
      expect(list, isNotNull);
      expect(list![0], 'b64');
      expect(r, isNotNull);
      await deleteRegistry(r);
      expect(await containsRegistryKey('1'), false);
      expect(registryByKey('1'), isNull);
    });

    test('should remove oldest registry and cache item', () async {
      final r1 = await saveToCache('1', ['s1'], const Duration(days: 1));
      final r2 = await saveToCache('2', ['s2'], const Duration(days: 1));
      final r3 = await saveToCache('3', ['s3'], const Duration(days: 1));
      expect(await cachedFirstItem(r1!), 's1');
      expect(await cachedFirstItem(r2!), 's2');
      expect(await cachedFirstItem(r3!), 's3');
      expect(await removeOldest(), true);
      expect(mockRegistries[0].key, '2');
      expect(await removeOldest(), true);
      expect(mockRegistries[0].key, '3');
      expect(await removeOldest(), true);
      expect(mockRegistries.isEmpty, true);
      expect(await removeOldest(), false);
    });

    test('should prepare space', () async {
      final r1 = await saveToCache('1', ['s1'], const Duration(days: 1));
      expect(await cachedList(r1!), isNotNull);
      expect(await containsRegistryKey(r1.key), true);

      var result = await prepareSpace(maxCachedSize - 1);
      expect(result, true);
      expect(await cachedList(r1), isNull);
      expect(await containsRegistryKey(r1.key), false);
    });

    test('should clean expired', () async {
      final r1 = await saveToCache('1', ['s1'], const Duration(days: -1));
      expect(await cachedList(r1!), isNotNull);
      expect(await containsRegistryKey(r1.key), true);

      final r2 = await saveToCache('2', ['s2'], const Duration(days: 1));
      expect(await cachedList(r2!), isNotNull);
      expect(await containsRegistryKey(r2.key), true);

      final r3 = await saveToCache('3', ['s3'], const Duration(days: -1));
      expect(await cachedList(r3!), isNotNull);
      expect(await containsRegistryKey(r3.key), true);

      cleanExpired();
      expect(await cachedList(r1), isNull);
      expect(await containsRegistryKey(r1.key), false);
      expect(await cachedList(r2), isNotNull);
      expect(await containsRegistryKey(r2.key), true);
      expect(await cachedList(r3), isNull);
      expect(await containsRegistryKey(r3.key), false);
      expect(mockRegistries.length, 1);
    });

    test('should save to cache and read from cache', () async {
      final result = await saveToCache('1', ['s1'], const Duration(days: 1));
      expect(result, isNotNull);
      mockRegistries = null;

      List<String>? list = await loadFromCache('1');
      expect(list, isNotNull);
      expect(list![0], 's1');
    });

    test('should update cache width new one', () async {
      final result = await saveToCache('1', ['s1'], const Duration(days: 1));
      expect(result, isNotNull);
      final result2 = await saveToCache('2', ['s2'], const Duration(days: 1));
      expect(result2, isNotNull);
      final result3 = await saveToCache('1', ['s3'], const Duration(days: 1));
      expect(result3, isNotNull);

      expect(mockRegistries.length, 2);
      expect(mockRegistries[0].key, '2');
      expect(await cachedFirstItem(result2!), 's2');
      expect(mockRegistries[1].key, '1');
      expect(await cachedFirstItem(result3!), 's3');
    });

    test('should cache fast', () async {
      for (var i = 0; i < 100; i++) {
        final result = await saveToCache('$i', ['$i data'], const Duration(days: 1));
        expect(result, isNotNull);
      }
    });
  });
}
