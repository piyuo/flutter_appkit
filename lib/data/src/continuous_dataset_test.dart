// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'indexed_db_provider.dart';
import 'continuous_dataset.dart';

void main() {
  group('[data.continuous_dataset]', () {
    test('init should load data from indexed db', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_json_map');
      await indexedDbProvider.init();

      final dataset = ContinuousDataset(
        rowsPerPage: 2,
        indexedDbProvider: indexedDbProvider,
        objectBuilder: () => sample.Person(),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(limit, (index) => sample.Person()..id = index.toString());
        },
      );
      await dataset.init();
      expect(dataset.isEmpty, true);

      await dataset.refresh();
      expect(dataset.isEmpty, false);
    });
  });
}
