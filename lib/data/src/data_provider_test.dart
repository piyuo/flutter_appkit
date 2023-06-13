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
        selector: (ds) => [ds['1'], ds['2']],
      );
      await dp.init();
      await dp.refresh();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');
      expect(dp.hasMore, false);
      expect(dp.noMore, true);
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
        selector: (ds) => [ds['1'], ds['2']],
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
      final p1 = sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp));
      final p2 = sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp));

      var viewerResult = [p1, p2];
      final indexedDb = IndexedDb(dbName: 'test_data_begin');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [p1, p2],
      );

      final dp = DataProvider(
        dataset: ds,
        selector: (ds) => viewerResult,
      );
      await dp.init();
      await dp.refresh();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');

      // sort changed, need begin new new
      viewerResult = [p2, p1];
      dp.begin();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '2');
      expect(dp.displayRows[1].id, '1');

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('refresh should call begin ', () async {
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
      );

      final dp = DataProvider(
        dataset: ds,
        selector: (ds) => viewerResult,
      );
      await dp.init();
      await dp.refresh();
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
  });
}
