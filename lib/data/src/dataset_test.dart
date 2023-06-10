// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'dataset.dart';
import 'indexed_db.dart';

void main() {
  group('[data.dataset]', () {
    test('should cache data in indexed db', () async {
      final indexedDbProvider = IndexedDb(dbName: 'test_dataset_keep');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final ds = Dataset<sample.Person>(
        db: indexedDbProvider,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [
          sample.Person()
            ..id = '1'
            ..timestamp = DateTime(2021, 1, 1).timestamp,
          sample.Person()
            ..id = '2'
            ..timestamp = DateTime(2021, 2, 1).timestamp,
        ],
      );
      await ds.init();
      await ds.refresh();

      final list = ds.query().toList();
      expect(list.length, 2);
      expect(list[0].id, '2');
      expect(list[1].id, '1');

      final ds2 = Dataset<sample.Person>(
        db: indexedDbProvider,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [],
      );
      await ds2.init();
      final list2 = ds2.query().toList();
      expect(list2.length, 2);
      expect(list2[0].id, '2');
      expect(list2[1].id, '1');

      ds.dispose();
      await indexedDbProvider.removeBox();
    });

    test('should remove expired data', () async {
      final indexedDbProvider = IndexedDb(dbName: 'test_dataset_expired');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final ds = Dataset(
          utcExpiredDate: DateTime(2021, 2, 1).toUtc(),
          db: indexedDbProvider,
          builder: () => sample.Person(),
          refresher: (timestamp) async => [
                sample.Person()
                  ..id = '1'
                  ..timestamp = DateTime(2021, 1, 1).utcTimestamp,
                sample.Person()
                  ..id = '2'
                  ..timestamp = DateTime(2021, 2, 1).utcTimestamp,
              ]);

      await ds.init();
      await ds.refresh();
      final list = ds.query().toList();
      expect(list.length, 2);
      expect(list[0].id, '2');
      expect(list[1].id, '1');

      final ds2 = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 2, 1).toUtc(),
        db: indexedDbProvider,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [],
      );
      await ds2.init();
      await ds2.removeExpired();
      final list2 = ds2.query().toList();
      expect(list2.length, 1);
      expect(list2[0].id, '2');
      ds.dispose();
      await indexedDbProvider.removeBox();
    });

    test('refresh should only add new data and sort', () async {
      var result = [
        sample.Person()
          ..id = '1'
          ..timestamp = DateTime(2021, 1, 1).timestamp,
      ];

      final indexedDbProvider = IndexedDb(dbName: 'test_dataset_refresh');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final ds = Dataset<sample.Person>(
        db: indexedDbProvider,
        builder: () => sample.Person(),
        refresher: (timestamp) async => result,
      );
      await ds.init();
      await ds.refresh();
      expect(ds.rows.length, 1);
      expect(ds.rows[0].id, '1');

      result = [
        sample.Person()
          ..id = '2'
          ..timestamp = DateTime(2021, 2, 1).timestamp,
      ];
      await ds.refresh();
      expect(ds.rows.length, 2);
      expect(ds.rows[0].id, '2');

      result = [
        sample.Person()
          ..id = '1'
          ..timestamp = DateTime(2021, 3, 1).timestamp,
      ];
      await ds.refresh();
      expect(ds.rows.length, 2);
      expect(ds.rows[0].id, '1');
      expect(ds.rows[0].timestamp.toDateTime().month, 3);

      result = [
        sample.Person()
          ..id = '2'
          ..timestamp = DateTime(2021, 1, 1).timestamp,
      ];
      await ds.refresh();
      expect(ds.rows.length, 2);
      expect(ds.rows[1].id, '2');
      expect(ds.rows[1].timestamp.toDateTime().month, 2);

      ds.dispose();
      await indexedDbProvider.removeBox();
    });

/*


    test('clear should clear all rows', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_local_db_clear');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final local = LocalDb(
        db: indexedDbProvider,
        builder: () => sample.Person(),
      );

      await local.init();
      await local.add([
        sample.Person()
          ..id = '1'
          ..timestamp = DateTime(2021, 1, 1).timestamp,
        sample.Person()
          ..id = '2'
          ..timestamp = DateTime.now().timestamp,
      ], false);

      await local.clear();
      final list = (await local.query(length: 2)).toList();
      expect(list.length, 0);

      final notExists = await local.getObjectById('1');
      expect(notExists, isNull);

      local.dispose();
      await indexedDbProvider.removeBox();
    });

    test('isNoMoreOnRemote should return [add] set value', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_local_db_no_more');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final local = LocalDb(
        db: indexedDbProvider,
        builder: () => sample.Person(),
      );

      await local.init();
      await local.add([], true);
      expect(local.isNoMoreOnRemote(), true);

      await local.add([], false);
      expect(local.isNoMoreOnRemote(), false);

      local.dispose();
      await indexedDbProvider.removeBox();
    });

    test('getNewestTime should return newest time', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_local_newest');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final local = LocalDb(
        db: indexedDbProvider,
        builder: () => sample.Person(),
      );

      await local.init();
      expect(local.getNewestTime(), isNull);
      await local.add([
        sample.Person()
          ..id = '1'
          ..timestamp = DateTime(2021, 1, 1).timestamp,
        sample.Person()
          ..id = '2'
          ..timestamp = DateTime(2021, 1, 2).timestamp,
      ], false);

      expect(local.getNewestTime()!.toDateTime().day, 2);

      local.dispose();
      await indexedDbProvider.removeBox();
    });

    test('getOldestTime should return oldest time', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_local_oldest');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final local = LocalDb(
        db: indexedDbProvider,
        builder: () => sample.Person(),
      );

      await local.init();
      expect(local.getOldestTime(), isNull);
      await local.add([
        sample.Person()
          ..id = '1'
          ..timestamp = DateTime(2021, 1, 1).timestamp,
        sample.Person()
          ..id = '2'
          ..timestamp = DateTime(2021, 1, 2).timestamp,
      ], false);

      expect(local.getOldestTime()!.toDateTime().day, 1);

      local.dispose();
      await indexedDbProvider.removeBox();
    });

    test('query should return result by filter', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_local_query');
      await indexedDbProvider.init();
      await indexedDbProvider.clear();

      final local = LocalDb(
        db: indexedDbProvider,
        builder: () => sample.Person(),
      );

      await local.init();
      expect(local.getOldestTime(), isNull);
      await local.add([
        sample.Person()
          ..id = '1'
          ..timestamp = DateTime(2021, 1, 1).timestamp,
        sample.Person()
          ..id = '2'
          ..timestamp = DateTime(2021, 1, 2).timestamp,
        sample.Person()
          ..id = '3'
          ..timestamp = DateTime(2021, 1, 3).timestamp,
        sample.Person()
          ..id = '4'
          ..deleted = true
          ..timestamp = DateTime(2021, 1, 4).timestamp,
        sample.Person()
          ..id = '5'
          ..timestamp = DateTime(2021, 1, 5).timestamp,
      ], false);

      final result = (await local.query(
        sortNewestFirst: false,
        from: DateTime(2021, 1, 2),
        to: DateTime(2021, 1, 4),
        length: 3,
      ))
          .toList();
      expect(result.length, 2);
      expect(result[0].t.toDateTime().day, 2);
      expect(result[1].t.toDateTime().day, 3);

      local.dispose();
      await indexedDbProvider.removeBox();
    });*/
  });
}
