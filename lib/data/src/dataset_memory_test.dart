// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/cache/cache.dart' as cache;
import 'dataset_memory.dart';

void main() {
  setUpAll(() async {});

  tearDown(() async {});

  tearDownAll(() async {});

  group('[data.dataset_memory]', () {
    test('should init and clear data', () async {
      final memoryProvider = cache.MemoryProvider(cacheDBName: 'dm_init_cache', timeDBName: 'dm_init_cache');
      await memoryProvider.init();
      final dataset = DatasetMemory<sample.Person>(
        memoryProvider: memoryProvider,
        name: 'test',
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      expect(dataset.noMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 0);
      expect(await dataset.first, isNull);
      expect(await dataset.last, isNull);
      await dataset.add([sample.Person(name: 'hi')]);
      expect(dataset.noMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 1);
      expect((await dataset.first)!.name, 'hi');
      expect((await dataset.last)!.name, 'hi');
      await dataset.reset();
      expect(dataset.noMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 0);
      expect(await dataset.first, isNull);
      expect(await dataset.last, isNull);
      await memoryProvider.removeBox();
    });
    test('should reload', () async {
      final memoryProvider = cache.MemoryProvider(cacheDBName: 'dm_reload_cache', timeDBName: 'dm_reload_cache');
      await memoryProvider.init();
      final dataset = DatasetMemory<sample.Person>(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset.load();
      expect(dataset.length, 0);

      final dataset2 = DatasetMemory<sample.Person>(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset2.load();
      await dataset2.add([sample.Person(name: 'hi')]);

      await dataset.load();
      expect(dataset.length, 1);
      await memoryProvider.removeBox();
    });

    test('should remove data', () async {
      final memoryProvider = cache.MemoryProvider(cacheDBName: 'dm_remove_cache', timeDBName: 'dm_remove_cache');
      await memoryProvider.init();
      final dataset = DatasetMemory<sample.Person>(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset.load();
      await dataset.insert([sample.Person()..id = 'first']);
      await dataset.insert([sample.Person()..id = 'second']);
      await dataset.insert([sample.Person()..id = 'third']);
      expect(dataset.length, 3);

      await dataset.delete(['first', 'third']);

      expect(dataset.length, 1);
      expect((await dataset.first)!.id, 'second');
      await memoryProvider.removeBox();
    });

    test('should remove duplicate when insert', () async {
      final memoryProvider = cache.MemoryProvider(cacheDBName: 'dm_duplicate_cache', timeDBName: 'dm_duplicate_cache');
      await memoryProvider.init();
      final dataset = DatasetMemory<sample.Person>(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset.load();
      await dataset.insert([sample.Person()..id = 'first']);
      expect(dataset.length, 1);

      // remove duplicate
      await dataset.insert([sample.Person()..id = 'first']);
      expect(dataset.length, 1);

      await dataset.insert([sample.Person()..id = 'second']);
      expect(dataset.length, 2);
      expect((await dataset.first)!.id, 'second');
      expect((await dataset.last)!.id, 'first');
      await memoryProvider.removeBox();
    });

    test('should remove duplicate when add', () async {
      final memoryProvider = cache.MemoryProvider(cacheDBName: 'dm_dup_add_cache', timeDBName: 'dm_dup_add_cache');
      await memoryProvider.init();
      final dataset = DatasetMemory<sample.Person>(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset.load();
      await dataset.add([sample.Person()..id = 'first']);
      expect(dataset.length, 1);

      // remove duplicate
      await dataset.add([sample.Person()..id = 'first']);
      expect(dataset.length, 1);

      await dataset.add([sample.Person()..id = 'second']);
      expect(dataset.length, 2);
      expect((await dataset.first)!.id, 'first');
      expect((await dataset.last)!.id, 'second');
      await memoryProvider.removeBox();
    });

    test('should get sub rows', () async {
      final memoryProvider = cache.MemoryProvider(cacheDBName: 'dm_sub_cache', timeDBName: 'dm_sub_cache');
      await memoryProvider.init();
      final dataset = DatasetMemory<sample.Person>(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset.load();
      var rows = await dataset.range(0);
      expect(rows.length, 0);

      await dataset.add([sample.Person()..id = 'first']);
      await dataset.add([sample.Person()..id = 'second']);
      rows = await dataset.range(0);
      expect(rows.length, 2);
      rows = await dataset.range(0, 2);
      expect(rows.length, 2);

      var rowsAll = await dataset.all;
      expect(rowsAll.length, 2);
      await memoryProvider.removeBox();
    });

    test('should save state', () async {
      final memoryProvider = cache.MemoryProvider(cacheDBName: 'dm_save_cache', timeDBName: 'dm_save_cache');
      await memoryProvider.init();
      final dataset = DatasetMemory<sample.Person>(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset.load();
      await dataset.add([sample.Person()..id = 'first']);
      await dataset.add([sample.Person()..id = 'second']);
      await dataset.setNoMore(true);
      await dataset.setRowsPerPage(21);

      final dataset2 = DatasetMemory<sample.Person>(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset2.load();
      expect(dataset2.noMore, true);
      expect(dataset2.rowsPerPage, 21);
      expect(dataset2.length, 2);
      expect((await dataset2.first)!.id, 'first');
      expect((await dataset2.last)!.id, 'second');
      await memoryProvider.removeBox();
    });

    test('should get row by id', () async {
      final memoryProvider = cache.MemoryProvider(cacheDBName: 'dm_row_cache', timeDBName: 'dm_row_cache');
      await memoryProvider.init();
      final dataset = DatasetMemory(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset.load();
      await dataset.add(List.generate(2, (i) => sample.Person()..id = '$i'));
      final obj = await dataset.read('1');
      expect(obj, isNotNull);
      expect(obj!.id, '1');
      final obj2 = await dataset.read('not-exist');
      expect(obj2, isNull);
      await memoryProvider.removeBox();
    });

    test('should use forEach to iterate all row', () async {
      final memoryProvider = cache.MemoryProvider(cacheDBName: 'dm_for_cache', timeDBName: 'dm_for_cache');
      await memoryProvider.init();
      final dataset = DatasetMemory<sample.Person>(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset.load();
      await dataset.add([sample.Person()..id = 'first']);
      await dataset.add([sample.Person()..id = 'second']);

      var count = 0;
      var id = '';
      await dataset.forEach((row) {
        count++;
        id = row.id;
      });
      expect(count, 2);
      expect(id, 'second');
      await memoryProvider.removeBox();
    });

    test('should check id exists', () async {
      final memoryProvider = cache.MemoryProvider(cacheDBName: 'dm_check_cache', timeDBName: 'dm_check_cache');
      await memoryProvider.init();
      final dataset = DatasetMemory<sample.Person>(
        name: 'test',
        objectBuilder: () => sample.Person(),
        memoryProvider: memoryProvider,
      );
      await dataset.load();
      await dataset.add([sample.Person()..id = 'first']);
      expect(dataset.isIDExists('first'), isTrue);
      expect(dataset.isIDExists('notExists'), isFalse);
      await memoryProvider.removeBox();
    });
  });
}
