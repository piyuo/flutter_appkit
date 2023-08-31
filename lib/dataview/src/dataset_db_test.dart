// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset_db.dart';

void main() {
  group('[data.data.dataset_db]', () {
    test('should init and clear data', () async {
      final dbProvider = data.IndexedDbProvider();
      await dbProvider.init('dd_init');
      await dbProvider.clear();
      final dataset = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      expect(dataset.noMore, true);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 0);
      expect(await dataset.first, isNull);
      expect(await dataset.last, isNull);
      await dataset.add([sample.Person(name: 'hi')]);
      expect(dataset.noMore, true);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 1);
      expect((await dataset.first)!.name, 'hi');
      expect((await dataset.last)!.name, 'hi');
      await dataset.reset();
      expect(dataset.noMore, true);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 0);
      expect(await dataset.first, isNull);
      expect(await dataset.last, isNull);
      await dbProvider.removeBox();
    });

    test('should load', () async {
      final dbProvider = data.IndexedDbProvider();
      await dbProvider.init('dd_load');
      await dbProvider.clear();
      final dataset = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      expect(dataset.length, 0);

      final dataset2 = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset2.load();
      await dataset2.add([sample.Person(name: 'hi')]);

      await dataset.load();
      expect(dataset.length, 1);
      await dbProvider.removeBox();
    });

    test('should remove duplicate when insert', () async {
      final dbProvider = data.IndexedDbProvider();
      await dbProvider.init('dd_remove_insert');
      await dbProvider.clear();
      final dataset = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      await dataset.insert([sample.Person(m: pb.Model(i: 'first'))]);
      expect(dataset.length, 1);

      // remove duplicate
      await dataset.insert([sample.Person(m: pb.Model(i: 'first'))]);
      expect(dataset.length, 1);

      await dataset.insert([sample.Person(m: pb.Model(i: 'second'))]);
      expect(dataset.length, 2);
      expect((await dataset.first)!.id, 'second');
      expect((await dataset.last)!.id, 'first');
      await dbProvider.removeBox();
    });

    test('should remove data', () async {
      final dbProvider = data.IndexedDbProvider();
      await dbProvider.init('dd_remove_data');
      await dbProvider.clear();
      final dataset = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      await dataset.insert([sample.Person(m: pb.Model(i: 'first'))]);
      await dataset.insert([sample.Person(m: pb.Model(i: 'second'))]);
      await dataset.insert([sample.Person(m: pb.Model(i: 'third'))]);
      expect(dataset.length, 3);

      await dataset.delete(['first', 'third']);

      expect(dataset.length, 1);
      expect((await dataset.first)!.id, 'second');
      await dbProvider.removeBox();
    });

    test('should remove duplicate when add', () async {
      final dbProvider = data.IndexedDbProvider();
      await dbProvider.init('dd_remove_add');
      await dbProvider.clear();
      final dataset = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      await dataset.add([sample.Person(m: pb.Model(i: 'first'))]);
      expect(dataset.length, 1);

      // remove duplicate
      await dataset.add([sample.Person(m: pb.Model(i: 'first'))]);
      expect(dataset.length, 1);

      await dataset.add([sample.Person(m: pb.Model(i: 'second'))]);
      expect(dataset.length, 2);
      expect((await dataset.first)!.id, 'first');
      expect((await dataset.last)!.id, 'second');
      await dbProvider.removeBox();
    });

    test('should get sub rows', () async {
      final dbProvider = data.IndexedDbProvider();
      await dbProvider.init('dd_sub_rows');
      await dbProvider.clear();
      final dataset = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      var rows = await dataset.range(0);
      expect(rows.length, 0);

      await dataset.add([sample.Person(m: pb.Model(i: 'first'))]);
      await dataset.add([sample.Person(m: pb.Model(i: 'second'))]);
      rows = await dataset.range(0);
      expect(rows.length, 2);
      rows = await dataset.range(0, 2);
      expect(rows.length, 2);

      var rowsAll = await dataset.all;
      expect(rowsAll.length, 2);
      await dbProvider.removeBox();
    });

    test('should save state', () async {
      final dbProvider = data.IndexedDbProvider();
      await dbProvider.init('dd_save_state');
      await dbProvider.clear();
      final dataset = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      await dataset.add([sample.Person(m: pb.Model(i: 'first'))]);
      await dataset.add([sample.Person(m: pb.Model(i: 'second'))]);
      await dataset.setNoMore(true);
      await dataset.setRowsPerPage(21);

      final dataset2 = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset2.load();
      expect(dataset2.noMore, true);
      expect(dataset2.rowsPerPage, 21);
      expect(dataset2.length, 2);
      expect((await dataset2.first)!.id, 'first');
      expect((await dataset2.last)!.id, 'second');
      await dbProvider.removeBox();
    });

    test('should get row by id', () async {
      final dbProvider = data.IndexedDbProvider();
      await dbProvider.init('dd_row_id');
      await dbProvider.clear();
      final dataset = DatasetDb(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      await dataset.add(List.generate(2, (i) => sample.Person(m: pb.Model(i: '$i'))));
      final obj = await dataset.read('1');
      expect(obj, isNotNull);
      expect(obj!.id, '1');
      final obj2 = await dataset.read('not-exist');
      expect(obj2, isNull);
      await dbProvider.removeBox();
    });

    test('should use forEach to iterate all row', () async {
      final dbProvider = data.IndexedDbProvider();
      await dbProvider.init('dd_for');
      await dbProvider.clear();
      final dataset = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      await dataset.add([sample.Person(m: pb.Model(i: 'first'))]);
      await dataset.add([sample.Person(m: pb.Model(i: 'second'))]);

      var count = 0;
      var id = '';
      await dataset.forEach((row) {
        count++;
        id = row.id;
      });
      expect(count, 2);
      expect(id, 'second');
      await dbProvider.removeBox();
    });

    test('should check id exists', () async {
      final dbProvider = data.IndexedDbProvider();
      await dbProvider.init('dd_check');
      await dbProvider.clear();
      final dataset = DatasetDb<sample.Person>(
        indexedDb: dbProvider,
        objectBuilder: () => sample.Person(),
      );
      await dataset.load();
      await dataset.add([sample.Person(m: pb.Model(i: 'first'))]);
      expect(dataset.isIDExists('first'), isTrue);
      expect(dataset.isIDExists('notExists'), isFalse);
      await dbProvider.removeBox();
    });
  });
}
