// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/testing/testing.dart' as testing;
import 'dataset_ram.dart';
import 'filtered_dataset.dart';
import 'filter.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[filtered_dataset]', () {
    test('should show all dataset row when no query', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);

      final filter = FilteredDataset(dataset);
      expect(filter.length, 2);
      expect((await filter.first)!.entityID, 'first');
      expect((await filter.last)!.entityID, 'second');
    });

    test('should filter keyword', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'first'))]);
      await dataset.add(testing.Context(), [sample.Person(entity: pb.Entity(id: 'second'))]);

      final filter = FilteredDataset(dataset);
      await filter.setFilters([FullTextFilter('first')]);
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
      await filter.setFilters([]);
      expect(filter.length, 6);
    });
  });
}
