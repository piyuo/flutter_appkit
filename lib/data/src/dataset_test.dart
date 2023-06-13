// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'dataset.dart';
import 'indexed_db.dart';

void main() {
  group('[data.dataset]', () {
    test('should cache data in indexed db', () async {
      final indexedDb = IndexedDb(dbName: 'test_dataset_keep');
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
      await ds.init();
      await ds.refresh();

      final list = ds.query().toList();
      expect(list.length, 2);
      expect(list[0].id, '2');
      expect(list[1].id, '1');

      final obj1 = ds.getRowById('1');
      expect(obj1!.id, '1');

      final ds2 = Dataset<sample.Person>(
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [],
      );
      await ds2.init();
      final list2 = ds2.query().toList();
      expect(list2.length, 2);
      expect(list2[0].id, '2');
      expect(list2[1].id, '1');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('should remove expired data', () async {
      final indexedDb = IndexedDb(dbName: 'test_dataset_expired');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset(
          utcExpiredDate: DateTime(2021, 2, 1).toUtc(),
          indexedDb: indexedDb,
          builder: () => sample.Person(),
          refresher: (timestamp) async => [
                sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
                sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 2, 1).utcTimestamp)),
              ]);

      await ds.init();
      await ds.refresh();
      final list = ds.query().toList();
      expect(list.length, 2);
      expect(list[0].id, '2');
      expect(list[1].id, '1');

      final ds2 = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 2, 1).toUtc(),
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [],
      );
      await ds2.init();
      await ds2.removeExpired();
      final list2 = ds2.query().toList();
      expect(list2.length, 1);
      expect(list2[0].id, '2');
      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('refresh should only add new data and sort', () async {
      var result = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
      ];

      final indexedDb = IndexedDb(dbName: 'test_dataset_refresh');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => result,
      );
      await ds.init();
      await ds.refresh();
      expect(ds.rows.length, 1);
      expect(ds.rows[0].id, '1');

      result = [
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 2, 1).utcTimestamp)),
      ];
      await ds.refresh();
      expect(ds.rows.length, 2);
      expect(ds.rows[0].id, '2');

      result = [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 3, 1).utcTimestamp)),
      ];
      await ds.refresh();
      expect(ds.rows.length, 2);
      expect(ds.rows[0].id, '1');
      expect(ds.rows[0].timestamp.toDateTime().month, 3);

      result = [
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 1).utcTimestamp)),
      ];
      await ds.refresh();
      expect(ds.rows.length, 2);
      expect(ds.rows[1].id, '2');
      expect(ds.rows[1].timestamp.toDateTime().month, 2);

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('should return timestamp to refresh data', () async {
      final indexedDb = IndexedDb(dbName: 'test_dataset_timestamp_latest');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset(
          utcExpiredDate: DateTime(2020, 1, 20).toUtc(),
          indexedDb: indexedDb,
          builder: () => sample.Person(),
          refresher: (timestamp) async => [
                sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
                sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
              ]);

      await ds.init();
      // no data, use expired date
      expect(ds.refreshTimestamp!.toDateTime(), DateTime(2020, 1, 20).toUtc());

      await ds.refresh();
      // use latest row as refresh timestamp
      expect(ds.refreshTimestamp!.toDateTime(), DateTime(2021, 1, 2).toUtc());
      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('should return null if need refresh to get all data', () async {
      final indexedDb = IndexedDb(dbName: 'test_dataset_timestamp_null');
      await indexedDb.init();
      await indexedDb.clear();
      final ds = Dataset<sample.Person>(
          indexedDb: indexedDb, builder: () => sample.Person(), refresher: (timestamp) async => []);

      await ds.init();
      await ds.refresh();
      expect(ds.refreshTimestamp, isNull);

      expect(ds.refreshTimestamp, isNull);
      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('query should return result by from,to and skipDeleted ', () async {
      final indexedDb = IndexedDb(dbName: 'test_dataset_query');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset(
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [
          sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
          sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp, d: true)),
          sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
          sample.Person(m: pb.Model(i: '5', t: DateTime(2021, 1, 5).utcTimestamp)),
        ],
      );

      await ds.init();
      await ds.refresh();

      final result = ds.query(from: DateTime(2021, 1, 2), to: DateTime(2021, 1, 4)).toList();
      expect(result.length, 2);
      expect(result[0].id, '4');
      expect(result[1].id, '2');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('query should return result by keyword', () async {
      final indexedDb = IndexedDb(dbName: 'test_dataset_keyword');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset(
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [
          sample.Person(name: 'john1', m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          sample.Person(name: 'john2', m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
          sample.Person(name: 'john3', m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp, d: true)),
          sample.Person(name: 'john4', m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
          sample.Person(name: 'john5', m: pb.Model(i: '5', t: DateTime(2021, 1, 5).utcTimestamp)),
        ],
      );

      await ds.init();
      await ds.refresh();

      final result = ds.query(keyword: 'John2').toList();
      expect(result.length, 1);
      expect(result[0].id, '2');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('query should return result by start and length', () async {
      final indexedDb = IndexedDb(dbName: 'test_dataset_start');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset(
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [
          sample.Person(name: 'john1', m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          sample.Person(name: 'john2', m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
          sample.Person(name: 'john3', m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp, d: true)),
          sample.Person(name: 'john4', m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
          sample.Person(name: 'john5', m: pb.Model(i: '5', t: DateTime(2021, 1, 5).utcTimestamp)),
        ],
      );

      await ds.init();
      await ds.refresh();

      final result = ds.query(start: 1, length: 2).toList();
      expect(result.length, 2);
      expect(result[0].id, '4');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('query should return result by filter', () async {
      final indexedDb = IndexedDb(dbName: 'test_dataset_filter');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset(
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [
          sample.Person(age: 17, m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          sample.Person(age: 18, m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
          sample.Person(age: 19, m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp, d: true)),
          sample.Person(age: 20, m: pb.Model(i: '4', t: DateTime(2021, 1, 4).utcTimestamp)),
          sample.Person(age: 21, m: pb.Model(i: '5', t: DateTime(2021, 1, 5).utcTimestamp)),
        ],
      );

      await ds.init();
      await ds.refresh();

      final result = ds.query(filter: (row) => row.age > 19).toList();
      expect(result.length, 2);
      expect(result[0].id, '5');
      expect(result[1].id, '4');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

/*    test('should map string list to object list', () async {
      final indexedDb = IndexedDb(dbName: 'test_dataset_map');
      await indexedDb.init();
      await indexedDb.clear();

      final ds = Dataset(
        indexedDb: indexedDb,
        builder: () => sample.Person(),
        refresher: (timestamp) async => [
          sample.Person(age: 17, m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          sample.Person(age: 18, m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
          sample.Person(age: 19, m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp, d: true)),
        ],
      );

      await ds.init();
      await ds.refresh();

      final result = ds.mapObjects(['2', '3']);
      expect(result.length, 2);
      // order by string list's order
      expect(result[0].id, '2');
      expect(result[1].id, '3');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });*/
  });
}
