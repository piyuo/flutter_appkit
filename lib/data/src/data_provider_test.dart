// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'data_provider.dart';
import 'dataset.dart';
import 'indexed_db.dart';
import 'change_finder.dart';

void main() {
  group('[data.data_provider]', () {
    test('should init with fetch data', () async {
      int fetchCount = 0;
      int fetchRows = 0;
      final dp = DataProvider<sample.Person>(
        rowsPerPage: 10,
        dataset: Dataset<sample.Person>(
          utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
          builder: () => sample.Person(),
          selector: (ds) => ds.query(),
        )..insertRow(
            sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 2, 1).utcTimestamp)),
          ),
        loader: (sync) async {
          fetchCount++;
          fetchRows = sync.rows;
          return (
            null,
            [
              sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
            ],
          );
        },
      );
      await dp.init();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');
      expect(dp.isMoreToFetch, isFalse);
      expect(dp.pageIndex, 1);
      expect(fetchCount, 1);
      expect(fetchRows, 9);

      // should not fetch when no more data
      final result2 = await dp.fetch();
      expect(result2, isFalse);
    });

    test('should change page index when fetch', () async {
      int fetchIndex = 0;

      final dp = DataProvider<sample.Person>(
        rowsPerPage: 1,
        dataset: Dataset<sample.Person>(
          utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
          builder: () => sample.Person(),
        )..insertRow(
            sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          ),
        loader: (sync) async {
          fetchIndex = sync.page;
          return (
            null,
            [
              sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
            ]
          );
        },
      );
      final result = await dp.fetch();
      expect(result, isTrue);
      expect(dp.displayRows.length, 1);
      expect(dp.displayRows[0].id, '1');
      expect(dp.isMoreToFetch, isTrue); // still have more data when download rows count == rowsPerPage
      expect(dp.pageIndex, 1);
      expect(fetchIndex, 0);

      final result2 = await dp.fetch();
      expect(result2, isTrue);
      expect(fetchIndex, 1);
      expect(dp.pageIndex, 2);
    });

    test('reload should reset pageIndex and no more', () async {
      List<sample.Person>? refreshResult;
      List<sample.Person>? fetchResult = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
      ];

      final dp = DataProvider<sample.Person>(
        rowsPerPage: 2,
        dataset: Dataset<sample.Person>(
          utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
          builder: () => sample.Person(),
          selector: (ds) => ds.query(),
        ),
        loader: (sync) async {
          return (refreshResult, fetchResult);
        },
      );
      await dp.init();
      expect(dp.displayRows.length, 1);
      expect(dp.isMoreToFetch, isFalse);
      expect(dp.pageIndex, 1);

      // mimic change result
      refreshResult = [
        sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp)),
      ];
      fetchResult = [
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
      ];
      await dp.reload();
      expect(dp.displayRows.length, 3);
      expect(dp.displayRows[0].id, '3');
      expect(dp.displayRows[1].id, '2');
      expect(dp.displayRows[2].id, '1');
      expect(dp.isMoreToFetch, isTrue);
      expect(dp.pageIndex, 1);
      fetchResult = [
        sample.Person(m: pb.Model(i: '4', t: DateTime(2020, 4, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '5', t: DateTime(2020, 2, 5).utcTimestamp)),
      ];

      final result = await dp.fetch();
      expect(result, isTrue);
      expect(dp.isMoreToFetch, isTrue);
      expect(dp.pageIndex, 2);
    });

    test('should cache data in indexed db', () async {
      final indexedDb = IndexedDb(dbName: 'test_data_keep');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        selector: (ds) => ds.query(),
      );

      final dp = DataProvider(
        dataset: ds,
        loader: (sync) async => (
          [
            sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
            sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 2, 1).utcTimestamp)),
          ],
          null
        ),
      );
      await dp.init(); // init will call refresh
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '2');
      expect(dp.displayRows[1].id, '1');
      expect(dp.isMoreToFetch, false);

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('should fetch more page', () async {
      var refreshResult = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
      ];
      var fetchResult = <sample.Person>[];

      final indexedDb = IndexedDb(dbName: 'test_data_more');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        selector: (ds) => ds.query(),
      );

      final dp = DataProvider<sample.Person>(
        dataset: ds,
        rowsPerPage: 2,
        loader: (timestamp) async => (refreshResult, fetchResult),
      );
      await dp.init();
      expect(dp.displayRows.length, 2);
      expect(dp.isMoreToFetch, isTrue);

      fetchResult = [
        sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp)),
        sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
      ];

      await dp.fetch();
      expect(dp.displayRows.length, 4);
      expect(dp.isMoreToFetch, isTrue);

      fetchResult = [
        sample.Person(m: pb.Model(i: '5', t: DateTime(2021, 1, 5).utcTimestamp)),
      ];
      await dp.fetch();
      expect(dp.displayRows.length, 5);
      expect(dp.isMoreToFetch, isFalse);

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('selector should able sort data', () async {
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
        selector: (ds) => viewerResult,
      );

      final dp = DataProvider(
        dataset: ds,
        loader: (timestamp) async => ([p1, p2], null),
      );
      await dp.init();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');

      // sort changed, need begin new new
      viewerResult = [p2, p1];
      await dp.reload();
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
        selector: (ds) => viewerResult,
      );

      final dp = DataProvider(
        dataset: ds,
        loader: (timestamp) async => (refreshResult, null),
      );
      await dp.init();
      expect(dp.displayRows.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '2');

      // refresh data
      refreshResult = [p3];
      viewerResult = [p1, p2, p3];
      final result = await dp.refresh();
      expect(result, isTrue);
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
        selector: (ds) => ds.query(),
      );

      final dp = DataProvider(
        dataset: ds,
        rowsPerPage: 5,
        loader: (timestamp) async => (
          [
            sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
            sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
          ],
          [
            sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp)),
            sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
          ],
        ),
      );
      await dp.init();
      expect(dp.displayRows.length, 4);
      expect(dp.isMoreToFetch, false);

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('should add/remove row', () async {
      final indexedDb = IndexedDb(dbName: 'test_data_add');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        selector: (ds) => ds.query(),
      )..insertRow(sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)));

      final dp = DataProvider<sample.Person>(
        dataset: ds,
        loader: (timestamp) async => (null, null),
      );
      await dp.init();
      expect(dp.displayRows.length, 1);
      final obj = sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 2).utcTimestamp));
      await dp.insertRow(obj);
      expect(dp.displayRows.length, 1);
      await dp.removeRow(obj);
      expect(dp.displayRows.length, 0);
      dp.dispose();
      await indexedDb.removeBox();
    });

    test('reload should reset fetch result and start from beginning', () async {
      var refreshResult = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
      ];
      var fetchResult = [
        sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp)),
        sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
      ];

      final indexedDb = IndexedDb(dbName: 'test_data_restart');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        selector: (ds) => ds.query(),
      );

      final dp = DataProvider<sample.Person>(
        dataset: ds,
        loader: (timestamp) async => (refreshResult, fetchResult),
        rowsPerPage: 5,
      );
      await dp.init();
      expect(dp.displayRows.length, 4);
      expect(dp.isMoreToFetch, false);

      fetchResult = [];
      await dp.reload();
      expect(dp.displayRows.length, 2);
      expect(dp.isMoreToFetch, false);

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
        selector: (ds) => ds.query(),
      );

      final dp = DataProvider<sample.Person>(
        dataset: ds,
        loader: (timestamp) async => (result, null),
      );
      await dp.init();
      expect(dp.displayRows.length, 4);

      result = [
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 3).utcTimestamp)), // change date
        sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 4).utcTimestamp, d: true)),
        sample.Person(m: pb.Model(i: '5', t: DateTime(2021, 1, 5).utcTimestamp)),
      ];

      final backup = List<sample.Person>.from(dp.displayRows);
      await dp.refresh();
      final changed = ChangeFinder<sample.Person>();
      changed.refreshDifference(source: backup, target: dp.displayRows);

      expect(dp.displayRows.length, 4);
      expect(changed.insertCount, 2);
      expect(changed.removed.length, 2);

      dp.dispose();
      await indexedDb.removeBox();
    });

    test('refresh should remove duplicate rows in fetchRows', () async {
      var refreshResult = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 2, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 2, 2).utcTimestamp)),
      ];

      var fetchResult = [
        sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp)),
        sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
      ];

      final indexedDb = IndexedDb(dbName: 'test_data_duplicate');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 1, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        selector: (ds) => ds.query(),
      );

      final dp = DataProvider<sample.Person>(
        dataset: ds,
        rowsPerPage: 5,
        loader: (timestamp) async => (refreshResult, fetchResult),
      );
      await dp.init();
      expect(dp.displayRows.length, 4);

      refreshResult = [
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 3, 5).utcTimestamp, d: true)), // change date
        sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 3, 6).utcTimestamp, d: true)),
      ];
      fetchResult = [];

      final backup = List<sample.Person>.from(dp.displayRows);
      await dp.refresh();
      final changed = ChangeFinder<sample.Person>();
      changed.refreshDifference(source: backup, target: dp.displayRows);

      expect(dp.displayRows.length, 2);
      expect(changed.removed.length, 2);
      expect(dp.displayRows[0].id, '1');
      expect(dp.displayRows[1].id, '3');

      dp.dispose();
      await indexedDb.removeBox();
    });
  });
}
