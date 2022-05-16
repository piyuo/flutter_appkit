// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[dataset_ram]', () {
    test('should init and clear data', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      expect(dataset.internalNoMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 0);
      expect(await dataset.first, isNull);
      expect(await dataset.last, isNull);
      await dataset.add(testing.Context(), [sample.Person(name: 'hi')]);
      expect(dataset.internalNoMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 1);
      expect((await dataset.first)!.name, 'hi');
      expect((await dataset.last)!.name, 'hi');
      await dataset.reset(testing.Context());
      expect(dataset.internalNoMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 0);
      expect(await dataset.first, isNull);
      expect(await dataset.last, isNull);
    });

    test('should remove duplicate when insert', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
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

    test('should remove data', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
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

    test('should remove duplicate when add', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
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
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
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

    test('should get row by id', () async {
      final dataset = DatasetRam(dataBuilder: () => sample.Person());
      dataset.add(testing.Context(), List.generate(2, (i) => sample.Person(entity: pb.Entity(id: '$i'))));
      final obj = await dataset.read('1');
      expect(obj, isNotNull);
      expect(obj!.entityID, '1');
      final obj2 = await dataset.read('not-exist');
      expect(obj2, isNull);
    });

    test('should set row and move to first', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.update(testing.Context(), sample.Person(entity: pb.Entity(id: 'first')));
      expect(dataset.length, 1);
      await dataset.update(testing.Context(), sample.Person(entity: pb.Entity(id: 'first')));
      expect(dataset.length, 1);
      await dataset.update(testing.Context(), sample.Person(entity: pb.Entity(id: 'second')));
      expect(dataset.length, 2);
      expect((await dataset.first)!.entityID, 'second');
      final obj = await dataset.read('first');
      expect(obj, isNotNull);
      final obj2 = await dataset.read('second');
      expect(obj2, isNotNull);
    });

    test('should use forEach to iterate all row', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
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
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(dataset.isIDExists('first'), isTrue);
      expect(dataset.isIDExists('notExists'), isFalse);
    });
  });
}
