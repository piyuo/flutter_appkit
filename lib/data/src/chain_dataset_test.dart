// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'indexed_db_provider.dart';
import 'chain_dataset.dart';

void main() {
  group('[data.chain_dataset]', () {
    test('refresh should load new data and save to database', () async {
      int generateCount = 2;
      int objIndex = 0;
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_refresh');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final dataset = ChainDataset(
        rowsPerPage: 3,
        indexedDbProvider: indexedDbProvider,
        objectBuilder: () => sample.Person(),
        loader: (
          isRefresh,
          limit,
          anchorTimestamp,
          anchorId,
        ) async {
          return List.generate(generateCount, (index) => sample.Person()..id = (objIndex++).toString());
        },
      );
      await dataset.init();
      expect(dataset.isEmpty, true);

      await dataset.refresh();
      expect(dataset.isEmpty, false);
      expect(dataset.length, 2);
      expect(dataset.isIdExists('0'), true);
      expect(dataset.isIdExists('1'), true);

      final dataset2 = ChainDataset(
        rowsPerPage: 3,
        indexedDbProvider: indexedDbProvider,
        objectBuilder: () => sample.Person(),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(limit, (index) => sample.Person()..id = index.toString());
        },
      );
      await dataset2.init();
      expect(dataset2.isEmpty, false);
      expect(dataset.length, 2);
      expect(dataset.isIdExists('0'), true);
      expect(dataset.isIdExists('1'), true);

      /// refresh 1 row
      generateCount = 1;
      await dataset.refresh();
      expect(dataset.length, 3);
      expect(dataset.isIdExists('2'), true);

      /// refresh 3 row, because 3 == rowsPerPage, it will reset the dataset
      generateCount = 3;
      await dataset.refresh();
      expect(dataset.length, 3);
      expect(dataset.isIdExists('3'), true);
      expect(dataset.isIdExists('4'), true);
      expect(dataset.isIdExists('5'), true);

      await indexedDbProvider.removeBox();
    });

    test('refresh should have no next page when dataset is empty and download row count < rows per page', () async {
      int generateCount = 2;
      int objIndex = 0;
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_refresh2');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final dataset = ChainDataset(
        rowsPerPage: 3,
        indexedDbProvider: indexedDbProvider,
        objectBuilder: () => sample.Person(),
        loader: (
          isRefresh,
          limit,
          anchorTimestamp,
          anchorId,
        ) async {
          return List.generate(generateCount, (index) => sample.Person()..id = (objIndex++).toString());
        },
      );
      await dataset.init();
      expect(dataset.isEmpty, true);

      await dataset.refresh();
      expect(dataset.isEmpty, false);
      expect(dataset.length, 2);
      expect(dataset.hasNextPage, false);
    });

    test('nextPage should not execute, until refresh() has been called', () async {
      int generateCount = 2;
      int objIndex = 0;
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_next_page');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final dataset = ChainDataset(
        rowsPerPage: 3,
        indexedDbProvider: indexedDbProvider,
        objectBuilder: () => sample.Person(),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(generateCount, (index) => sample.Person()..id = (objIndex++).toString());
        },
      );
      await dataset.init();
      expect(dataset.isEmpty, true);
      expect(dataset.hasNextPage, false);

      await dataset.nextPage();
      expect(dataset.isEmpty, true);
      expect(dataset.hasNextPage, false);

      await indexedDbProvider.removeBox();
    });

    test('nextPage should load more data and save to database', () async {
      int generateCount = 3;
      int objIndex = 0;
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_next_page2');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final dataset = ChainDataset(
        rowsPerPage: 3,
        indexedDbProvider: indexedDbProvider,
        objectBuilder: () => sample.Person(),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(generateCount, (index) => sample.Person()..id = (objIndex++).toString());
        },
      );
      await dataset.init();
      expect(dataset.isEmpty, true);
      expect(dataset.hasNextPage, false);

      await dataset.refresh();
      expect(dataset.length, 3);
      expect(dataset.hasNextPage, true);

      await dataset.nextPage();
      expect(dataset.length, 6);
      expect(dataset.hasNextPage, true);

      generateCount = 2;
      await dataset.nextPage();
      expect(dataset.length, 8);
      expect(dataset.hasNextPage, false);

      final dataset2 = ChainDataset(
        rowsPerPage: 3,
        indexedDbProvider: indexedDbProvider,
        objectBuilder: () => sample.Person(),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(limit, (index) => sample.Person()..id = index.toString());
        },
      );
      await dataset2.init();
      expect(dataset2.isEmpty, false);
      expect(dataset.length, 8);
      expect(dataset.isIdExists('0'), true);
      expect(dataset.isIdExists('7'), true);

      await indexedDbProvider.removeBox();
    });
  });
}
