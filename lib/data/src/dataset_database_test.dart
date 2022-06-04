// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/database/database.dart' as database;
import 'package:libcli/testing/testing.dart' as testing;
import 'dataset_database.dart';

void main() {
  setUpAll(() async {
    await database.initForTest();
    await database.delete('test');
  });

  tearDown(() async {
    await database.delete('test');
  });

  group('[dataset_database]', () {
    test('should init and clear data', () async {
      final dataset = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      expect(dataset.noMore, true);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 0);
      expect(await dataset.first, isNull);
      expect(await dataset.last, isNull);
      await dataset.add(testing.Context(), [sample.Person(name: 'hi')]);
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
    });

    test('should load', () async {
      final dataset = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      expect(dataset.length, 0);

      final dataset2 = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset2.load(testing.Context());
      await dataset2.add(testing.Context(), [sample.Person(name: 'hi')]);

      await dataset.load(testing.Context());
      expect(dataset.length, 1);
    });

    test('should remove duplicate when insert', () async {
      final dataset = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.insert(testing.Context(), [sample.Person()..id = 'first']);
      expect(dataset.length, 1);

      // remove duplicate
      await dataset.insert(testing.Context(), [sample.Person()..id = 'first']);
      expect(dataset.length, 1);

      await dataset.insert(testing.Context(), [sample.Person()..id = 'second']);
      expect(dataset.length, 2);
      expect((await dataset.first)!.id, 'second');
      expect((await dataset.last)!.id, 'first');
    });

    test('should remove data', () async {
      final dataset = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.insert(testing.Context(), [sample.Person()..id = 'first']);
      await dataset.insert(testing.Context(), [sample.Person()..id = 'second']);
      await dataset.insert(testing.Context(), [sample.Person()..id = 'third']);
      expect(dataset.length, 3);

      await dataset.delete(testing.Context(), [
        sample.Person()..id = 'first',
        sample.Person()..id = 'third',
      ]);

      expect(dataset.length, 1);
      expect((await dataset.first)!.id, 'second');
    });

    test('should remove duplicate when add', () async {
      final dataset = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.add(testing.Context(), [sample.Person()..id = 'first']);
      expect(dataset.length, 1);

      // remove duplicate
      await dataset.add(testing.Context(), [sample.Person()..id = 'first']);
      expect(dataset.length, 1);

      await dataset.add(testing.Context(), [sample.Person()..id = 'second']);
      expect(dataset.length, 2);
      expect((await dataset.first)!.id, 'first');
      expect((await dataset.last)!.id, 'second');
    });

    test('should get sub rows', () async {
      final dataset = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      var rows = await dataset.range(0);
      expect(rows.length, 0);

      await dataset.add(testing.Context(), [sample.Person()..id = 'first']);
      await dataset.add(testing.Context(), [sample.Person()..id = 'second']);
      rows = await dataset.range(0);
      expect(rows.length, 2);
      rows = await dataset.range(0, 2);
      expect(rows.length, 2);

      var rowsAll = await dataset.all;
      expect(rowsAll.length, 2);
    });
    test('should save state', () async {
      final dataset = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.add(testing.Context(), [sample.Person()..id = 'first']);
      await dataset.add(testing.Context(), [sample.Person()..id = 'second']);
      await dataset.setNoMore(testing.Context(), true);
      await dataset.setRowsPerPage(testing.Context(), 21);

      final dataset2 = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset2.load(testing.Context());
      expect(dataset2.noMore, true);
      expect(dataset2.rowsPerPage, 21);
      expect(dataset2.length, 2);
      expect((await dataset2.first)!.id, 'first');
      expect((await dataset2.last)!.id, 'second');
    });

    test('should get row by id', () async {
      final dataset = DatasetDatabase(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.add(testing.Context(), List.generate(2, (i) => sample.Person()..id = '$i'));
      final obj = await dataset.read('1');
      expect(obj, isNotNull);
      expect(obj!.id, '1');
      final obj2 = await dataset.read('not-exist');
      expect(obj2, isNull);
    });

    test('should use forEach to iterate all row', () async {
      final dataset = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.add(testing.Context(), [sample.Person()..id = 'first']);
      await dataset.add(testing.Context(), [sample.Person()..id = 'second']);

      var count = 0;
      var id = '';
      await dataset.forEach((row) {
        count++;
        id = row.id;
      });
      expect(count, 2);
      expect(id, 'second');
    });

    test('should check id exists', () async {
      final dataset = DatasetDatabase<sample.Person>(await database.open('test'), dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      await dataset.add(testing.Context(), [sample.Person()..id = 'first']);
      expect(dataset.isIDExists('first'), isTrue);
      expect(dataset.isIDExists('notExists'), isFalse);
    });
  });
}
