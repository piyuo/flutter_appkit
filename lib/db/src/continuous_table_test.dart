// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'continuous_table.dart';
import 'memory_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[continuous_table]', () {
    test('should refresh on start', () async {
      int refreshCount = 0;
      ContinuousTable dataSet = ContinuousTable(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          int limit = 10;
          if (refreshCount == 1) {
            limit = 2;
          }
          refreshCount++;
          return List.generate(limit, (i) => sample.Person(entity: pb.Entity(id: '$refreshCount$i')));
        },
      );
      await dataSet.open(testing.Context());

      // should read 10 rows
      expect(dataSet.length, 10);
      expect(dataSet.displayRows.length, 10);
      expect(dataSet.isEmpty, false);
      expect(dataSet.isNotEmpty, true);

      // should read 2 rows and display all
      await dataSet.refresh(testing.Context());
      expect(dataSet.length, 12);
      expect(dataSet.displayRows.length, 12);
      expect(dataSet.isEmpty, false);
      expect(dataSet.isNotEmpty, true);

      await dataSet.close();
    });

    test('should remove duplicate data when refresh', () async {
      final ds = ContinuousTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test2',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async =>
            [sample.Person(entity: pb.Entity(id: 'duplicate'))],
      );
      await ds.open(testing.Context());
      await ds.refresh(testing.Context());
      // second refresh will delete duplicate data
      expect(ds.length, 1);
    });

    test('should not reset on refresh', () async {
      int idCount = 0;
      final ds = ContinuousTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          idCount++;
          return List.generate(
              10,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: idCount.toString(),
                      updateTime: DateTime.now().utcTimestamp,
                    ),
                  ));
        },
      );
      await ds.open(testing.Context());
      expect(ds.noMore, true);
      expect(ds.length, 10);
      await ds.refresh(testing.Context());
      expect(ds.noMore, true);
      expect(ds.length, 20);
    });

    test('should send anchor to refresher', () async {
      int idCount = 0;
      int? _limit;
      google.Timestamp? _anchorTimestamp;
      String? _anchorId;

      final ds = ContinuousTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          _limit = 10;
          _anchorTimestamp = anchorTimestamp;
          _anchorId = anchorId;
          idCount++;
          return List.generate(
              10,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: idCount.toString(),
                      updateTime: DateTime.now().utcTimestamp,
                    ),
                  ));
        },
      );
      await ds.open(testing.Context());
      expect(_limit, 10);
      expect(_anchorTimestamp, isNull);
      expect(_anchorId, isNull);

      await ds.refresh(testing.Context());
      expect(_limit, 10);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '1');
    });

    test('should save state', () async {
      final cs = ContinuousTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          return [sample.Person(entity: pb.Entity(id: 'only', updateTime: DateTime.now().utcTimestamp))];
        },
      );
      await cs.open(testing.Context());
      expect(cs.length, 1);
      expect(cs.rowsPerPage, 10);
      final cs2 = ContinuousTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async => [],
      );
      await cs2.open(testing.Context());
      expect(cs.length, 1);
      expect(cs.rowsPerPage, 10);
    });

    test('should goto page', () async {
      final cs = ContinuousTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          return [sample.Person(entity: pb.Entity(id: 'only', updateTime: DateTime.now().utcTimestamp))];
        },
      );
      await cs.open(testing.Context());
      expect(cs.length, 1);
      expect(cs.rowsPerPage, 10);
      final cs2 = ContinuousTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async => [],
      );
      await cs2.open(testing.Context());
      expect(cs.length, 1);
      expect(cs.rowsPerPage, 10);
    });
  });
}
