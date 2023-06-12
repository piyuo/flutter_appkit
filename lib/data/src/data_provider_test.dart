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
      );

      final dp = DataProvider(
        dataset: ds,
        viewer: (ds) => [
          ['1', '2']
        ],
      );
      await dp.init();
      await dp.refresh();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');
      expect(dp.totalPages, 1);
      expect(dp.pageIndex, 0);
      expect(dp.hasMore, false);
      expect(dp.noMore, true);
      expect(dp.hasNextPage, false);
      expect(dp.noNextPage, true);
      expect(dp.isEnd, true);
      dp.dispose();
      await indexedDb.removeBox();
    });

    test('should get next page', () async {
      final indexedDb = IndexedDb(dbName: 'test_data_next');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [
          sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 2, 1).utcTimestamp)),
        ],
      );

      final dp = DataProvider(
        dataset: ds,
        viewer: (ds) => [
          ['1'],
          ['2']
        ],
      );
      await dp.init();
      await dp.refresh();
      expect(dp.displayRows.length, 1);

      dp.nextPage();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');
      expect(dp.totalPages, 2);
      expect(dp.pageIndex, 1);

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
      );

      final dp = DataProvider(
        dataset: ds,
        viewer: (ds) => [
          ['1', '2']
        ],
        fetcher: DataFetcher<sample.Person>(
          rowsPerPage: 2,
          loader: (timestamp, rowsPerPage, pageIndex) async {
            return refreshResult;
          },
        ),
      );
      await dp.init();
      await dp.refresh();
      expect(dp.displayRows.length, 2);
      expect(dp.hasMore, true);
      expect(dp.hasNextPage, false);

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

    test('should begin a new view ', () async {
      var viewerResult = [
        ['1'],
        ['2']
      ];
      final indexedDb = IndexedDb(dbName: 'test_data_begin');
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
      );

      final dp = DataProvider(
        dataset: ds,
        viewer: (ds) => viewerResult,
      );
      await dp.init();
      await dp.refresh();
      expect(dp.displayRows.length, 1);
      expect(dp.totalPages, 2);
      expect(dp.hasNextPage, true);
      dp.nextPage();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');
      expect(dp.hasNextPage, false);

      // sort changed, need begin new new
      viewerResult = [
        ['2'],
        ['1']
      ];
      dp.begin();
      expect(dp.displayRows.length, 1);
      expect(dp.totalPages, 2);
      expect(dp.hasNextPage, true);
      dp.nextPage();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '2');
      expect(dp.displayRows[1].id, '1');
      expect(dp.hasNextPage, false);

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('refresh should begin a new view ', () async {
      var refreshResult = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
      ];
      var viewerResult = [
        ['1'],
        ['2']
      ];
      final indexedDb = IndexedDb(dbName: 'test_data_refresh_begin');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => refreshResult,
      );

      final dp = DataProvider(
        dataset: ds,
        viewer: (ds) => viewerResult,
      );
      await dp.init();
      await dp.refresh();
      expect(dp.displayRows.length, 1);
      expect(dp.totalPages, 2);
      expect(dp.hasNextPage, true);
      dp.nextPage();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');
      expect(dp.hasNextPage, false);

      // refresh data
      refreshResult = [
        sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp)),
      ];
      viewerResult = [
        ['1'],
        ['2'],
        ['3']
      ];
      await dp.refresh();
      expect(dp.displayRows.length, 1);
      expect(dp.totalPages, 3);
      expect(dp.hasNextPage, true);
      dp.nextPage();
      expect(dp.displayRows.length, 2);
      dp.nextPage();
      expect(dp.displayRows.length, 3);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');
      expect(dp.displayRows[2].id, '3');
      expect(dp.hasNextPage, false);

      dp.dispose();
      await indexedDb.removeBox();
    });
  });
}
