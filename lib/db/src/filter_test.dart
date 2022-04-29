// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/testing/testing.dart' as testing;
import 'memory_ram.dart';
import 'filter.dart';
import 'query.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[filter]', () {
    test('should show all memory row when no query', () async {
      final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
      await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);

      final filter = Filter(memory);
      expect(filter.length, 2);
      expect((await filter.first)!.entityID, 'first');
      expect((await filter.last)!.entityID, 'second');
    });

    test('should filter keyword', () async {
      final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
      await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      await memory.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);

      final filter = Filter(memory);
      await filter.setQueries([FullTextQuery('first')]);
      expect(filter.length, 1);
      expect((await filter.first)!.entityID, 'first');

      // show keep filter when insert new data
      await filter.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'third'))]);
      expect(filter.length, 1);
      expect((await filter.first)!.entityID, 'first');
      await filter.insert(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first2'))]);
      expect(filter.length, 2);
      expect((await filter.first)!.entityID, 'first2');

      // show keep filter when add new data
      await filter.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'thirdAdd'))]);
      expect(filter.length, 2);
      expect((await filter.first)!.entityID, 'first2');
      await filter.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first3'))]);
      expect(filter.length, 3);
      expect((await filter.first)!.entityID, 'first2');
      expect((await filter.last)!.entityID, 'first3');

      // remove query will show all rows
      await filter.setQueries([]);
      expect(filter.length, 6);
    });
  });
}
