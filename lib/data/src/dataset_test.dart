// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/testing/testing.dart' as testing;
import 'dataset_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[dataset]', () {
    test('should count page row', () async {
      final dataset = DatasetRam(dataBuilder: () => sample.Person());
      expect(dataset.internalNoMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 0);
      expect(dataset.isEmpty, true);
      expect(dataset.isNotEmpty, false);
      dataset.add(testing.Context(), [sample.Person()]);
      expect(dataset.internalNoMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 1);
      expect(dataset.isEmpty, false);
      expect(dataset.isNotEmpty, true);
    });

    test('should call onChanged when update data', () async {
      bool changed = false;
      final dataset = DatasetRam(
        dataBuilder: () => sample.Person(),
      );

      await dataset.insert(testing.Context(), [sample.Person()]);
      expect(changed, true);

      changed = false;
      await dataset.add(testing.Context(), [sample.Person()]);
      expect(changed, true);

      changed = false;
      await dataset.delete(testing.Context(), [sample.Person()]);
      expect(changed, true);

      changed = false;
      await dataset.reset(testing.Context());
      expect(changed, true);

      changed = false;
      await dataset.reset(testing.Context());
      expect(changed, true);

      changed = false;
      await dataset.update(testing.Context(), sample.Person());
      expect(changed, true);
    });
  });
}
