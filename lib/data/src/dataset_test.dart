// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/net/net.dart' as net;
import 'package:libcli/sample/sample.dart' as sample;
import 'dataset.dart';
import 'indexed_provider_db.dart';

void main() {
  group('[data.dataset]', () {
    test('should not cache data if no indexed db', () async {
      final ds = Dataset<sample.Person>(
        builder: () => sample.Person(),
      );
      await ds.init();
      await ds.insertRows(
        [
          sample.Person(m: net.Model(i: '1', t: DateTime(2021, 1, 1).timestamp)),
          sample.Person(m: net.Model(i: '2', t: DateTime(2021, 2, 1).timestamp)),
        ],
      );

      final list = ds.query().toList();
      expect(list.length, 2);
      expect(list[0].id, '2');
      expect(list[1].id, '1');

      final obj1 = ds.getRowById('1');
      expect(obj1!.id, '1');

      final ds2 = Dataset<sample.Person>(
        builder: () => sample.Person(),
      );
      await ds2.init();
      final list2 = ds2.query().toList();
      expect(list2.length, 0);
    });

    test('should cache data in indexed db', () async {
      final indexedDb = IndexedDbProvider();
      await indexedDb.init('test_dataset_keep');
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        builder: () => sample.Person(),
      );
      await ds.init(
        indexedDbProvider: indexedDb,
      );
      await ds.insertRows([
        sample.Person(m: net.Model(i: '1', t: DateTime(2021, 1, 1).timestamp)),
        sample.Person(m: net.Model(i: '2', t: DateTime(2021, 2, 1).timestamp)),
      ]);

      final list = ds.query().toList();
      expect(list.length, 2);
      expect(list[0].id, '2');
      expect(list[1].id, '1');

      final obj1 = ds.getRowById('1');
      expect(obj1!.id, '1');

      final ds2 = Dataset<sample.Person>(
        builder: () => sample.Person(),
      );
      await ds2.init(
        indexedDbProvider: indexedDb,
      );
      final list2 = ds2.query().toList();
      expect(list2.length, 2);
      expect(list2[0].id, '2');
      expect(list2[1].id, '1');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('should remove expired data', () async {
      final indexedDb = IndexedDbProvider();
      await indexedDb.init('test_dataset_expired');
      await indexedDb.clear();

      final ds = Dataset(
        utcExpiredDate: DateTime(2021, 2, 1).toUtc(),
        builder: () => sample.Person(),
      );

      await ds.init(
        indexedDbProvider: indexedDb,
      );
      await ds.insertRows([
        sample.Person(m: net.Model(i: '1', t: DateTime(2021, 1, 1).timestamp)),
        sample.Person(m: net.Model(i: '2', t: DateTime(2021, 2, 1).timestamp)),
      ]);
      final list = ds.query().toList();
      expect(list.length, 2);
      expect(list[0].id, '2');
      expect(list[1].id, '1');

      final ds2 = Dataset<sample.Person>(
        utcExpiredDate: DateTime(2021, 2, 1).toUtc(),
        builder: () => sample.Person(),
      );
      await ds2.init(
        indexedDbProvider: indexedDb,
      );
      await ds2.removeExpired();
      final list2 = ds2.query().toList();
      expect(list2.length, 1);
      expect(list2[0].id, '2');
      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('refresh should only add new data and sort', () async {
      final indexedDb = IndexedDbProvider();
      await indexedDb.init('test_dataset_refresh');
      await indexedDb.clear();

      final ds = Dataset<sample.Person>(
        builder: () => sample.Person(),
      );
      await ds.init(
        indexedDbProvider: indexedDb,
      );
      await ds.insertRows([
        sample.Person(m: net.Model(i: '1', t: DateTime(2021, 1, 1).timestamp)),
      ]);
      expect(ds.rows.length, 1);
      expect(ds.rows[0].id, '1');

      await ds.insertRows([
        sample.Person(m: net.Model(i: '2', t: DateTime(2021, 2, 1).timestamp)),
      ]);
      expect(ds.rows.length, 2);
      expect(ds.rows[0].id, '2');

      await ds.insertRows([
        sample.Person(m: net.Model(i: '1', t: DateTime(2021, 3, 1).timestamp)),
      ]);
      expect(ds.rows.length, 2);
      expect(ds.rows[0].id, '1');
      expect(ds.rows[0].timestamp.toDateTime().month, 3);

      await ds.insertRows([
        sample.Person(m: net.Model(i: '2', t: DateTime(2021, 1, 1).timestamp)),
      ]);
      expect(ds.rows.length, 2);
      expect(ds.rows[1].id, '2');
      expect(ds.rows[1].timestamp.toDateTime().month, 2);

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('should return timestamp to refresh data', () async {
      final indexedDb = IndexedDbProvider();
      await indexedDb.init('test_dataset_timestamp_latest');
      await indexedDb.clear();

      final ds = Dataset(
        utcExpiredDate: DateTime(2020, 1, 20).toUtc(),
        builder: () => sample.Person(),
      );

      await ds.init(
        indexedDbProvider: indexedDb,
      );
      // no data, use expired date
      expect(ds.refreshTimestamp!.toDateTime(), DateTime(2020, 1, 20).toUtc());

      await ds.insertRows([
        sample.Person(m: net.Model(i: '1', t: DateTime(2021, 1, 1).timestamp)),
        sample.Person(m: net.Model(i: '2', t: DateTime(2021, 1, 2).timestamp)),
      ]);
      // use latest row as refresh timestamp
      expect(ds.refreshTimestamp!.toDateTime(), DateTime(2021, 1, 2).toUtc());
      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('should return null if need refresh to get all data', () async {
      final indexedDb = IndexedDbProvider();
      await indexedDb.init('test_dataset_timestamp_null');
      await indexedDb.clear();
      final ds = Dataset<sample.Person>(
        builder: () => sample.Person(),
      );

      await ds.init(
        indexedDbProvider: indexedDb,
      );
      expect(ds.refreshTimestamp, isNull);

      expect(ds.refreshTimestamp, isNull);
      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('query should return result by from,to and skipDeleted ', () async {
      final indexedDb = IndexedDbProvider();
      await indexedDb.init('test_dataset_query');
      await indexedDb.clear();

      final ds = Dataset(
        builder: () => sample.Person(),
      );

      await ds.init(
        indexedDbProvider: indexedDb,
      );
      await ds.insertRows([
        sample.Person(m: net.Model(i: '1', t: DateTime(2021, 1, 1).timestamp)),
        sample.Person(m: net.Model(i: '2', t: DateTime(2021, 1, 2).timestamp)),
        sample.Person(m: net.Model(i: '3', t: DateTime(2021, 1, 3).timestamp, d: true)),
        sample.Person(m: net.Model(i: '4', t: DateTime(2021, 1, 4).timestamp)),
        sample.Person(m: net.Model(i: '5', t: DateTime(2021, 1, 5).timestamp)),
      ]);

      final result = ds.query(from: DateTime(2021, 1, 2), to: DateTime(2021, 1, 4)).toList();
      expect(result.length, 2);
      expect(result[0].id, '4');
      expect(result[1].id, '2');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('query should return result by keyword', () async {
      final indexedDb = IndexedDbProvider();
      await indexedDb.init('test_dataset_keyword');
      await indexedDb.clear();

      final ds = Dataset(
        builder: () => sample.Person(),
      );

      await ds.init(
        indexedDbProvider: indexedDb,
      );
      await ds.insertRows([
        sample.Person(name: 'john1', m: net.Model(i: '1', t: DateTime(2021, 1, 1).timestamp)),
        sample.Person(name: 'john2', m: net.Model(i: '2', t: DateTime(2021, 1, 2).timestamp)),
        sample.Person(name: 'john3', m: net.Model(i: '3', t: DateTime(2021, 1, 3).timestamp, d: true)),
        sample.Person(name: 'john4', m: net.Model(i: '4', t: DateTime(2021, 1, 4).timestamp)),
        sample.Person(name: 'john5', m: net.Model(i: '5', t: DateTime(2021, 1, 5).timestamp)),
      ]);

      final result = ds.query(keyword: 'John2').toList();
      expect(result.length, 1);
      expect(result[0].id, '2');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('query should return result by start and length', () async {
      final indexedDb = IndexedDbProvider();
      await indexedDb.init('test_dataset_start');
      await indexedDb.clear();

      final ds = Dataset(
        builder: () => sample.Person(),
      );

      await ds.init(
        indexedDbProvider: indexedDb,
      );
      await ds.insertRows([
        sample.Person(name: 'john1', m: net.Model(i: '1', t: DateTime(2021, 1, 1).timestamp)),
        sample.Person(name: 'john2', m: net.Model(i: '2', t: DateTime(2021, 1, 2).timestamp)),
        sample.Person(name: 'john3', m: net.Model(i: '3', t: DateTime(2021, 1, 3).timestamp, d: true)),
        sample.Person(name: 'john4', m: net.Model(i: '4', t: DateTime(2021, 1, 4).timestamp)),
        sample.Person(name: 'john5', m: net.Model(i: '5', t: DateTime(2021, 1, 5).timestamp)),
      ]);

      final result = ds.query(start: 1, length: 2).toList();
      expect(result.length, 2);
      expect(result[0].id, '4');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });

    test('query should return result by filter', () async {
      final indexedDb = IndexedDbProvider();
      await indexedDb.init('test_dataset_filter');
      await indexedDb.clear();

      final ds = Dataset(
        builder: () => sample.Person(),
      );

      await ds.init(
        indexedDbProvider: indexedDb,
      );
      await ds.insertRows([
        sample.Person(age: 17, m: net.Model(i: '1', t: DateTime(2021, 1, 1).timestamp)),
        sample.Person(age: 18, m: net.Model(i: '2', t: DateTime(2021, 1, 2).timestamp)),
        sample.Person(age: 19, m: net.Model(i: '3', t: DateTime(2021, 1, 3).timestamp, d: true)),
        sample.Person(age: 20, m: net.Model(i: '4', t: DateTime(2021, 1, 4).timestamp)),
        sample.Person(age: 21, m: net.Model(i: '5', t: DateTime(2021, 1, 5).timestamp)),
      ]);

      final result = ds.query(filter: (row) => row.age > 19).toList();
      expect(result.length, 2);
      expect(result[0].id, '5');
      expect(result[1].id, '4');

      indexedDb.dispose();
      await indexedDb.removeBox();
    });
  });
}
