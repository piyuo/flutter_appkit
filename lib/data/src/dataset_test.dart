// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'dataset_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[dataset]', () {
    test('should count page row', () async {
      final dataset = DatasetRam(objectBuilder: () => sample.Person());
      expect(dataset.internalNoMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 0);
      expect(dataset.isEmpty, true);
      expect(dataset.isNotEmpty, false);
      dataset.add([sample.Person()]);
      expect(dataset.internalNoMore, false);
      expect(dataset.rowsPerPage, 10);
      expect(dataset.length, 1);
      expect(dataset.isEmpty, false);
      expect(dataset.isNotEmpty, true);
    });
  });
}
