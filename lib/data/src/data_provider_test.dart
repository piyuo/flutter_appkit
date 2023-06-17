// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'data_provider.dart';
import 'data_fetcher.dart';
import 'dataset.dart';
import 'indexed_db.dart';

void main() {
  group('[data.data_provider]', () {
    test('should cache data in indexed db', () async {
      final indexedDb = IndexedDb(dbName: 'test_data_keep');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [
          sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 2, 1).utcTimestamp)),
        ],
        selector: (ds) => [ds['1'], ds['2']],
      );

      final dp = DataProvider(
        dataset: ds,
      );
      await dp.init(); // init will call refresh
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');
      expect(dp.hasMore, false);
      expect(dp.noMore, true);
      expect(dp.isNotFilledPage, false);

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('should fetch more page', () async {
      var refreshResult = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
      ];

      final indexedDb = IndexedDb(dbName: 'test_data_more');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => refreshResult,
        selector: (ds) => [ds['1'], ds['2']],
      );

      final dp = DataProvider(
        dataset: ds,
        fetcher: DataFetcher<sample.Person>(
          rowsPerPage: 2,
          loader: (timestamp, rowsPerPage, pageIndex) async {
            return refreshResult;
          },
        ),
      );
      await dp.init();
      expect(dp.displayRows.length, 2);
      expect(dp.hasMore, true);

      refreshResult = [
        sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp)),
        sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
      ];
      await dp.more();
      expect(dp.displayRows.length, 4);
      expect(dp.hasMore, true);

      refreshResult = [
        sample.Person(m: pb.Model(i: '5', t: DateTime(2021, 1, 5).utcTimestamp)),
      ];
      await dp.more();
      expect(dp.displayRows.length, 5);
      expect(dp.hasMore, false);

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('should reload from dataset', () async {
      final p1 = sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp));
      final p2 = sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp));

      var viewerResult = [p1, p2];
      final indexedDb = IndexedDb(dbName: 'test_data_reload');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [p1, p2],
        selector: (ds) => viewerResult,
      );

      final dp = DataProvider(
        dataset: ds,
      );
      await dp.init();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');

      // sort changed, need begin new new
      viewerResult = [p2, p1];
      await dp.restart();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '2');
      expect(dp.displayRows[1].id, '1');

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('refresh should not reset data', () async {
      final p1 = sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp));
      final p2 = sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp));
      final p3 = sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp));

      var refreshResult = [p1, p2];
      var viewerResult = [p1, p2];
      final indexedDb = IndexedDb(dbName: 'test_data_refresh_begin');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => refreshResult,
        selector: (ds) => viewerResult,
      );

      final dp = DataProvider(
        dataset: ds,
      );
      await dp.init();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');

      // refresh data
      refreshResult = [p3];
      viewerResult = [p1, p2, p3];
      await dp.refresh();
      expect(dp.displayRows.length, 3);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');
      expect(dp.displayRows[2].id, '3');

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('should fill page with more if display rows is less then one page', () async {
      final indexedDb = IndexedDb(dbName: 'test_data_fill');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [
          sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
        ],
        selector: (ds) => [ds['1'], ds['2']],
      );

      final dp = DataProvider(
        dataset: ds,
        fetcher: DataFetcher<sample.Person>(
          rowsPerPage: 5,
          loader: (timestamp, rowsPerPage, pageIndex) async {
            return [
              sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 1).utcTimestamp)),
              sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 1, 2).utcTimestamp)),
            ];
          },
        ),
      );
      await dp.init();
      expect(dp.displayRows.length, 4);
      expect(dp.hasMore, false);
      expect(dp.isNotFilledPage, true);

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('restart should reset fetch result and start from beginning', () async {
      var result = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
      ];

      final indexedDb = IndexedDb(dbName: 'test_data_restart');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => result,
        selector: (ds) => [ds['1'], ds['2']],
      );

      final dp = DataProvider(
        dataset: ds,
        fetcher: DataFetcher<sample.Person>(
          rowsPerPage: 5,
          loader: (timestamp, rowsPerPage, pageIndex) async {
            return result;
          },
        ),
      );
      await dp.init();
      expect(dp.displayRows.length, 4);
      expect(dp.hasMore, false);
      expect(dp.isNotFilledPage, true);

      result = [];
      await dp.restart();
      expect(dp.displayRows.length, 2);
      expect(dp.hasMore, false);
      expect(dp.isNotFilledPage, true);

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('refresh should find difference', () async {
      var result = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
        sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp)),
        sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
      ];

      final indexedDb = IndexedDb(dbName: 'test_data_diff');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => result,
        selector: (ds) => ds.query(),
      );

      final dp = DataProvider(
        dataset: ds,
      );
      await dp.init();
      expect(dp.displayRows.length, 4);

      result = [
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 3).utcTimestamp)), // change date
        sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 4).utcTimestamp, d: true)),
        sample.Person(m: pb.Model(i: '5', t: DateTime(2021, 1, 5).utcTimestamp)),
      ];
      final changed = await dp.refresh(findDifference: true);
      expect(dp.displayRows.length, 4);
      expect(changed!.insertCount, 2);
      expect(changed.removed.length, 2);

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('refresh should remove duplicate rows in fetchRows', () async {
      var result = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 2, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 2, 2).utcTimestamp)),
      ];

      final indexedDb = IndexedDb(dbName: 'test_data_duplicate');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => result,
        selector: (ds) => ds.query(),
      );

      final dp = DataProvider(
        dataset: ds,
        fetcher: DataFetcher<sample.Person>(
          rowsPerPage: 5,
          loader: (timestamp, rowsPerPage, pageIndex) async {
            return [
              sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp)),
              sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
            ];
          },
        ),
      );
      await dp.init();
      expect(dp.displayRows.length, 4);

      result = [
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 3, 5).utcTimestamp, d: true)), // change date
        sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 3, 6).utcTimestamp, d: true)),
      ];
      final changed = await dp.refresh(findDifference: true);
      expect(dp.displayRows.length, 2);
      expect(changed!.removed.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '3');

      dp.dispose();
      await indexedDb.removeBox();
    });
  });
}
