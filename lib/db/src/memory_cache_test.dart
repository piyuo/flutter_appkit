// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/testing/testing.dart' as testing;
import 'memory_cache.dart';
import 'cache.dart';
import 'db.dart';

void main() {
  setUpAll(() async {
    await initDBForTest();
  });

  group('[memory_cache]', () {
    test('should init and clear data', () async {
      final cache = await openCache('memory_cache_test_1', 'memory_cache_test_time_1');
      await cache.reset();
      try {
        final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory.open();
        expect(memory.noMore, false);
        expect(memory.rowsPerPage, 10);
        expect(memory.length, 0);
        expect(await memory.first, isNull);
        expect(await memory.last, isNull);
        await memory.add(testing.Context(), [sample.Person(name: 'hi')]);
        expect(memory.noMore, false);
        expect(memory.rowsPerPage, 10);
        expect(memory.length, 1);
        expect((await memory.first)!.name, 'hi');
        expect((await memory.last)!.name, 'hi');
        await memory.clear(testing.Context());
        expect(memory.noMore, false);
        expect(memory.rowsPerPage, 10);
        expect(memory.length, 0);
        expect(await memory.first, isNull);
        expect(await memory.last, isNull);
      } finally {
        await deleteCache('memory_cache_test_1', 'memory_cache_test_time_1');
      }
    });
    test('should reload', () async {
      final cache = await openCache('memory_cache_test_1', 'memory_cache_test_time_1');
      await cache.reset();
      final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      expect(memory.length, 0);

      final memory2 = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
      await memory2.open();
      await memory2.add(testing.Context(), [sample.Person(name: 'hi')]);

      await memory.reload();
      expect(memory.length, 1);
    });

    test('should remove data', () async {
      final cache = await openCache('memory_cache_test_1', 'memory_cache_test_time_1');
      await cache.reset();
      final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      await memory.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      await memory.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);
      await memory.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'third'))]);
      expect(memory.length, 3);

      await memory.delete(testing.Context(), [
        sample.Person(entity: pb.Entity(id: 'first')),
        sample.Person(entity: pb.Entity(id: 'third')),
      ]);

      expect(memory.length, 1);
      expect((await memory.first)!.entityID, 'second');
    });

    test('should remove duplicate when insert', () async {
      final cache = await openCache('memory_cache_test_2', 'memory_cache_test_time_2');
      await cache.reset();
      try {
        final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory.open();
        await memory.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
        expect(memory.length, 1);

        // remove duplicate
        await memory.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
        expect(memory.length, 1);

        await memory.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);
        expect(memory.length, 2);
        expect((await memory.first)!.entityID, 'second');
        expect((await memory.last)!.entityID, 'first');
      } finally {
        await deleteCache('memory_cache_test_2', 'memory_cache_test_time_2');
      }
    });

    test('should remove duplicate when add', () async {
      final cache = await openCache('memory_cache_test_3', 'memory_cache_test_time_3');
      await cache.reset();
      try {
        final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory.open();
        await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
        expect(memory.length, 1);

        // remove duplicate
        await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
        expect(memory.length, 1);

        await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);
        expect(memory.length, 2);
        expect((await memory.first)!.entityID, 'first');
        expect((await memory.last)!.entityID, 'second');
      } finally {
        await deleteCache('memory_cache_test_3', 'memory_cache_test_time_3');
      }
    });

    test('should get sub rows', () async {
      final cache = await openCache('memory_cache_test_4', 'memory_cache_test_time_4');
      await cache.reset();
      try {
        final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory.open();
        var rows = memory.range(0);
        expect(rows.length, 0);

        await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
        await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);
        rows = memory.range(0);
        expect(rows.length, 2);
        rows = memory.range(0, 2);
        expect(rows.length, 2);

        var rowsAll = memory.all;
        expect(rowsAll.length, 2);
      } finally {
        await deleteCache('memory_cache_test_4', 'memory_cache_test_time_4');
      }
    });
    test('should save state', () async {
      final cache = await openCache('memory_cache_test_5', 'memory_cache_test_time_5');
      await cache.reset();
      try {
        final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory.open();
        await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
        await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);
        await memory.setNoMore(testing.Context(), true);
        await memory.setRowsPerPage(testing.Context(), 21);
        await memory.close();

        final memory2 = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory2.open();
        expect(memory2.noMore, true);
        expect(memory2.rowsPerPage, 21);
        expect(memory2.length, 2);
        expect((await memory2.first)!.entityID, 'first');
        expect((await memory2.last)!.entityID, 'second');
      } finally {
        await deleteCache('memory_cache_test_5', 'memory_cache_test_time_5');
      }
    });

    test('should not delete in reset after max item limit', () async {
      final cache = await openCache('memory_cache_test_6', 'memory_cache_test_time_6');
      await cache.reset();
      try {
        final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory.open();
        await memory.add(
            testing.Context(), List.generate(maxResetItem + 1, (i) => sample.Person(entity: pb.Entity(id: '$i'))));

        expect(cache.contains('0'), true);
        expect(cache.contains(maxResetItem.toString()), true);
        await memory.clear(testing.Context());
        expect(cache.contains('0'), false);
        expect(cache.contains(maxResetItem.toString()), true);
      } finally {
        await deleteCache('memory_cache_test_6', 'memory_cache_test_time_6');
      }
    });

    test('should get row by id', () async {
      final cache = await openCache('memory_cache_test_7', 'memory_cache_test_time_7');
      await cache.reset();
      try {
        final memory = MemoryCache(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory.open();
        await memory.add(testing.Context(), List.generate(2, (i) => sample.Person(entity: pb.Entity(id: '$i'))));
        final obj = await memory.read('1');
        expect(obj, isNotNull);
        expect(obj!.entityID, '1');
        final obj2 = await memory.read('not-exist');
        expect(obj2, isNull);
      } finally {
        await deleteCache('memory_cache_test_7', 'memory_cache_test_time_7');
      }
    });

    test('should set row and move to first', () async {
      final cache = await openCache('memory_cache_test_8', 'memory_cache_test_time_8');
      await cache.reset();
      try {
        final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory.open();
        await memory.update(testing.Context(), sample.Person(entity: pb.Entity(id: 'first')));
        expect(memory.length, 1);
        await memory.update(testing.Context(), sample.Person(entity: pb.Entity(id: 'first')));
        expect(memory.length, 1);
        await memory.update(testing.Context(), sample.Person(entity: pb.Entity(id: 'second')));
        expect(memory.length, 2);
        expect((await memory.first)!.entityID, 'second');
        final obj = await memory.read('first');
        expect(obj, isNotNull);
        final obj2 = await memory.read('second');
        expect(obj2, isNotNull);
      } finally {
        await deleteCache('memory_cache_test_8', 'memory_cache_test_time_8');
      }
    });

    test('should use forEach to iterate all row', () async {
      final cache = await openCache('memory_cache_test_9', 'memory_cache_test_time_9');
      await cache.reset();
      try {
        final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory.open();
        await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
        await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);

        var count = 0;
        var id = '';
        await memory.forEach((row) {
          count++;
          id = row.entityID;
        });
        expect(count, 2);
        expect(id, 'second');
      } finally {
        await deleteCache('memory_cache_test_9', 'memory_cache_test_time_9');
      }
    });

    test('should check id exists', () async {
      final cache = await openCache('memory_cache_test_9', 'memory_cache_test_time_9');
      await cache.reset();
      try {
        final memory = MemoryCache<sample.Person>(cache, name: 'test', dataBuilder: () => sample.Person());
        await memory.open();
        await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
        expect(memory.isIDExists('first'), isTrue);
        expect(memory.isIDExists('notExists'), isFalse);
      } finally {
        await deleteCache('memory_cache_test_9', 'memory_cache_test_time_9');
      }
    });

    test('should call onChanged when update data', () async {
      final cache = await openCache('memory_cache_test_9', 'memory_cache_test_time_9');
      await cache.reset();
      bool changed = false;
      final memory = MemoryCache<sample.Person>(
        cache,
        name: 'test',
        dataBuilder: () => sample.Person(),
        onChanged: (context) => changed = true,
      );
      await memory.open();

      await memory.insert(testing.Context(), [sample.Person()]);
      expect(changed, true);

      changed = false;
      await memory.add(testing.Context(), [sample.Person()]);
      expect(changed, true);

      changed = false;
      await memory.delete(testing.Context(), [sample.Person()]);
      expect(changed, true);

      changed = false;
      await memory.clear(testing.Context());
      expect(changed, true);

      changed = false;
      await memory.clear(testing.Context());
      expect(changed, true);

      changed = false;
      await memory.update(testing.Context(), sample.Person());
      expect(changed, true);
    });
  });
}
