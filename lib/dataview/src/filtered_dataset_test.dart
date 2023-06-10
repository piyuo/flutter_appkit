// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset_ram.dart';
import 'filtered_dataset.dart';
import 'filter.dart';

void main() {
  group('[data.filtered_dataset]', () {
    test('should show all dataset row when no query', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      await dataset.add([sample.Person(m: pb.Model(i: 'first'))]);
      await dataset.add([sample.Person(m: pb.Model(i: 'second'))]);

      final filter = FilteredDataset(dataset);
      expect(filter.length, 2);
      expect((await filter.first)!.id, 'first');
      expect((await filter.last)!.id, 'second');
    });

    test('should filter keyword', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      await dataset.add([sample.Person(m: pb.Model(i: 'first'))]);
      await dataset.add([sample.Person(m: pb.Model(i: 'second'))]);

      final filter = FilteredDataset(dataset);
      await filter.setFilters([FullTextFilter('first')]);
      expect(filter.length, 1);
      expect((await filter.first)!.id, 'first');

      // show keep filter when insert new data
      await filter.insert([sample.Person(m: pb.Model(i: 'third'))]);
      expect(filter.length, 1);
      expect((await filter.first)!.id, 'first');
      await filter.insert([sample.Person(m: pb.Model(i: 'first2'))]);
      expect(filter.length, 2);
      expect((await filter.first)!.id, 'first2');

      // show keep filter when add new data
      await filter.add([sample.Person(m: pb.Model(i: 'thirdAdd'))]);
      expect(filter.length, 2);
      expect((await filter.first)!.id, 'first2');
      await filter.add([sample.Person(m: pb.Model(i: 'first3'))]);
      expect(filter.length, 3);
      expect((await filter.first)!.id, 'first2');
      expect((await filter.last)!.id, 'first3');

      // remove query will show all rows
      await filter.setFilters([]);
      expect(filter.length, 6);
    });
  });
}
