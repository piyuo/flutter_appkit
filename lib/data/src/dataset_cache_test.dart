// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/database/database.dart' as database;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/testing/testing.dart' as testing;
import 'dataset_cache.dart';

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

  group('[dataset_cache]', () {
    test('should init and clear data', () async {
      final dataset = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      expect(dataset.noMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 0);
      expect(await dataset.first, isNull);
      expect(await dataset.last, isNull);
      await dataset.add(testing.Context(), [sample.Person(name: 'hi')]);
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
    });
    test('should reload', () async {
      final dataset = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      expect(dataset.length, 0);

      final dataset2 = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset2.load(testing.Context());
      await dataset2.add(testing.Context(), [sample.Person(name: 'hi')]);

      await dataset.load(testing.Context());
      expect(dataset.length, 1);
    });

    test('should remove data', () async {
      final dataset = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      await dataset.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);
      await dataset.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'third'))]);
      expect(dataset.length, 3);

      await dataset.delete(testing.Context(), [
        sample.Person(entity: pb.Entity(id: 'first')),
        sample.Person(entity: pb.Entity(id: 'third')),
      ]);

      expect(dataset.length, 1);
      expect((await dataset.first)!.entityID, 'second');
    });

    test('should remove duplicate when insert', () async {
      final dataset = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(dataset.length, 1);

      // remove duplicate
      await dataset.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(dataset.length, 1);

      await dataset.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);
      expect(dataset.length, 2);
      expect((await dataset.first)!.entityID, 'second');
      expect((await dataset.last)!.entityID, 'first');
    });

    test('should remove duplicate when add', () async {
      final dataset = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(dataset.length, 1);

      // remove duplicate
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(dataset.length, 1);

      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);
      expect(dataset.length, 2);
      expect((await dataset.first)!.entityID, 'first');
      expect((await dataset.last)!.entityID, 'second');
    });

    test('should get sub rows', () async {
      final dataset = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      var rows = await dataset.range(0);
      expect(rows.length, 0);

      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);
      rows = await dataset.range(0);
      expect(rows.length, 2);
      rows = await dataset.range(0, 2);
      expect(rows.length, 2);

      var rowsAll = await dataset.all;
      expect(rowsAll.length, 2);
    });
    test('should save state', () async {
      final dataset = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);
      await dataset.setNoMore(testing.Context(), true);
      await dataset.setRowsPerPage(testing.Context(), 21);

      final dataset2 = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset2.load(testing.Context());
      expect(dataset2.noMore, true);
      expect(dataset2.rowsPerPage, 21);
      expect(dataset2.length, 2);
      expect((await dataset2.first)!.entityID, 'first');
      expect((await dataset2.last)!.entityID, 'second');
    });
    test('should get row by id', () async {
      final dataset = DatasetCache(name: 'test', dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.add(testing.Context(), List.generate(2, (i) => sample.Person(entity: pb.Entity(id: '$i'))));
      final obj = await dataset.read('1');
      expect(obj, isNotNull);
      expect(obj!.entityID, '1');
      final obj2 = await dataset.read('not-exist');
      expect(obj2, isNull);
    });

    test('should use forEach to iterate all row', () async {
      final dataset = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);

      var count = 0;
      var id = '';
      await dataset.forEach((row) {
        count++;
        id = row.entityID;
      });
      expect(count, 2);
      expect(id, 'second');
    });

    test('should check id exists', () async {
      final dataset = DatasetCache<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(dataset.isIDExists('first'), isTrue);
      expect(dataset.isIDExists('notExists'), isFalse);
    });
  });
}
