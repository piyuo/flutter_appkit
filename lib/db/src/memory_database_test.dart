// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'memory_database.dart';
import 'db.dart';

void main() {
  setUpAll(() async {
    await initDBForTest();
  });

  setUp(() async {
    await deleteMemoryDatabase('test');
  });

  tearDownAll(() async {
    await deleteMemoryDatabase('test');
  });

  group('[memory_cache]', () {
    test('should init and clear data', () async {
      final memory = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      expect(memory.noMore, true);
      expect(memory.rowsPerPage, 10);
      expect(memory.length, 0);
      expect(await memory.first, isNull);
      expect(await memory.last, isNull);
      await memory.add([sample.Person(name: 'hi')]);
      expect(memory.noMore, true);
      expect(memory.rowsPerPage, 10);
      expect(memory.length, 1);
      expect((await memory.first)!.name, 'hi');
      expect((await memory.last)!.name, 'hi');
      await memory.clear();
      expect(memory.noMore, true);
      expect(memory.rowsPerPage, 10);
      expect(memory.length, 0);
      expect(await memory.first, isNull);
      expect(await memory.last, isNull);
    });

    test('should remove duplicate when insert', () async {
      final memory = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      await memory.insert([sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(memory.length, 1);

      // remove duplicate
      await memory.insert([sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(memory.length, 1);

      await memory.insert([sample.Person(entity: pb.Entity(id: 'second'))]);
      expect(memory.length, 2);
      expect((await memory.first)!.entityID, 'second');
      expect((await memory.last)!.entityID, 'first');
    });

    test('should remove duplicate when add', () async {
      final memory = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      await memory.add([sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(memory.length, 1);

      // remove duplicate
      await memory.add([sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(memory.length, 1);

      await memory.add([sample.Person(entity: pb.Entity(id: 'second'))]);
      expect(memory.length, 2);
      expect((await memory.first)!.entityID, 'first');
      expect((await memory.last)!.entityID, 'second');
    });

    test('should get sub rows', () async {
      final memory = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      var rows = await memory.subRows(0);
      expect(rows!.length, 0);

      await memory.add([sample.Person(entity: pb.Entity(id: 'first'))]);
      await memory.add([sample.Person(entity: pb.Entity(id: 'second'))]);
      rows = await memory.subRows(0);
      expect(rows!.length, 2);
      rows = await memory.subRows(0, 2);
      expect(rows!.length, 2);

      var rowsAll = await memory.allRows;
      expect(rowsAll!.length, 2);
    });
    test('should save state', () async {
      final memory = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      await memory.add([sample.Person(entity: pb.Entity(id: 'first'))]);
      await memory.add([sample.Person(entity: pb.Entity(id: 'second'))]);
      memory.noMore = true;
      memory.rowsPerPage = 21;
      await memory.save();
      await memory.close();

      final memory2 = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
      await memory2.open();
      expect(memory2.noMore, true);
      expect(memory2.rowsPerPage, 21);
      expect(memory2.length, 2);
      expect((await memory2.first)!.entityID, 'first');
      expect((await memory2.last)!.entityID, 'second');
    });

    test('should get row by id', () async {
      final memory = MemoryDatabase(id: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      await memory.add(List.generate(2, (i) => sample.Person(entity: pb.Entity(id: '$i'))));
      final obj = await memory.getRowByID('1');
      expect(obj, isNotNull);
      expect(obj!.entityID, '1');
      final obj2 = await memory.getRowByID('not-exist');
      expect(obj2, isNull);
    });

    test('should set row and move to first', () async {
      final memory = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      await memory.setRow(sample.Person(entity: pb.Entity(id: 'first')));
      expect(memory.length, 1);
      await memory.setRow(sample.Person(entity: pb.Entity(id: 'first')));
      expect(memory.length, 1);
      await memory.setRow(sample.Person(entity: pb.Entity(id: 'second')));
      expect(memory.length, 2);
      expect((await memory.first)!.entityID, 'second');
      final obj = await memory.getRowByID('first');
      expect(obj, isNotNull);
      final obj2 = await memory.getRowByID('second');
      expect(obj2, isNotNull);
    });

    test('should use forEach to iterate all row', () async {
      final memory = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      await memory.add([sample.Person(entity: pb.Entity(id: 'first'))]);
      await memory.add([sample.Person(entity: pb.Entity(id: 'second'))]);

      var count = 0;
      var id = '';
      await memory.forEach((row) {
        count++;
        id = row.entityID;
      });
      expect(count, 2);
      expect(id, 'second');
    });

    test('should check id exists', () async {
      final memory = MemoryDatabase<sample.Person>(id: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      await memory.add([sample.Person(entity: pb.Entity(id: 'first'))]);
      expect(memory.isIDExists('first'), isTrue);
      expect(memory.isIDExists('notExists'), isFalse);
    });
  });
}
