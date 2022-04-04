// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'paged_table.dart';
import 'memory_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[paged_table]', () {
    test('should refresh on start', () async {
      int refreshCount = 0;
      PagedTable dataSet = PagedTable(
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
      await dataSet.start(testing.Context());

      // should read 10 rows
      expect(dataSet.length, 10);
      expect(dataSet.displayRows.length, 10);
      expect(dataSet.isEmpty, false);
      expect(dataSet.isNotEmpty, true);

      // should read 2 rows
      await dataSet.refresh(testing.Context());
      expect(dataSet.length, 12);
      expect(dataSet.displayRows.length, 10);
      expect(dataSet.isEmpty, false);
      expect(dataSet.isNotEmpty, true);

      await dataSet.close();
    });

    test('should remove duplicate data when refresh', () async {
      final ds = PagedTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test2',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async =>
            [sample.Person(entity: pb.Entity(id: 'duplicate'))],
      );
      await ds.start(testing.Context());
      await ds.refresh(testing.Context());
      // second refresh will delete duplicate data
      expect(ds.length, 1);
    });

    test('should not reset on refresh', () async {
      int idCount = 0;
      final ds = PagedTable<sample.Person>(
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
      await ds.start(testing.Context());
      expect(ds.noMoreData, true);
      expect(ds.length, 10);
      await ds.refresh(testing.Context());
      expect(ds.noMoreData, true);
      expect(ds.length, 20);
    });

    test('should send anchor to refresher', () async {
      int idCount = 0;
      int? _limit;
      google.Timestamp? _anchorTimestamp;
      String? _anchorId;

      final ds = PagedTable<sample.Person>(
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
      await ds.start(testing.Context());
      expect(_limit, 10);
      expect(_anchorTimestamp, isNull);
      expect(_anchorId, isNull);

      await ds.refresh(testing.Context());
      expect(_limit, 10);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '1');
    });

    test('should save state', () async {
      final cs = PagedTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          return [sample.Person(entity: pb.Entity(id: 'only', updateTime: DateTime.now().utcTimestamp))];
        },
      );
      await cs.start(testing.Context());
      expect(cs.length, 1);
      expect(cs.rowsPerPage, 10);
      final cs2 = PagedTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async => [],
      );
      await cs2.start(testing.Context());
      expect(cs.length, 1);
      expect(cs.rowsPerPage, 10);
    });

    test('should goto page', () async {
      final cs = PagedTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          return [sample.Person(entity: pb.Entity(id: 'only', updateTime: DateTime.now().utcTimestamp))];
        },
      );
      await cs.start(testing.Context());
      expect(cs.length, 1);
      expect(cs.rowsPerPage, 10);
      final cs2 = PagedTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async => [],
      );
      await cs2.start(testing.Context());
      expect(cs.length, 1);
      expect(cs.rowsPerPage, 10);
    });

    test('should load next/prev/last/first page', () async {
      int step = 0;
      final ds = PagedTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person(entity: pb.Entity(id: 'init' + index.toString())));
          }
          if (step == 1) {
            // next page
            step++;
            return List.generate(2, (index) => sample.Person(entity: pb.Entity(id: 'next' + index.toString())));
          }
          if (step == 2) {
            // refresh
            step++;
            return List.generate(2, (index) => sample.Person(entity: pb.Entity(id: 'refresh' + index.toString())));
          }
          return [];
        },
      );
      await ds.start(testing.Context());
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, false);
      expect(ds.displayRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noMoreData, true);
      expect(ds.pageIndex, 0);
      expect(ds.length, 10);

      await ds.refresh(testing.Context());
      await ds.nextPage(testing.Context());
      expect(ds.hasPrevPage, true);
      expect(ds.hasNextPage, false);
      expect(ds.displayRows.length, 2);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noMoreData, true);
      expect(ds.pageIndex, 1);
      expect(ds.length, 12);

      await ds.prevPage(testing.Context());
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.displayRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noMoreData, true);
      expect(ds.pageIndex, 0);
      expect(ds.length, 12);

      await ds.refresh(testing.Context());
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.displayRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noMoreData, true);
      expect(ds.pageIndex, 0);
      expect(ds.length, 14);

      await ds.refresh(testing.Context());
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.displayRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noMoreData, true);
      expect(ds.pageIndex, 0);
      expect(ds.length, 14);
    });

    test('should goto page and show info', () async {
      int step = 0;
      final ds = PagedTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person(entity: pb.Entity(id: 'init' + index.toString())));
          }
          if (step == 1) {
            // first refresh
            step++;
            return List.generate(
                limit, (index) => sample.Person(entity: pb.Entity(id: 'firstRefresh' + index.toString())));
          }
          if (step == 2) {
            // second refresh
            step++;
            return List.generate(
                2, (index) => sample.Person(entity: pb.Entity(id: 'secondRefresh' + index.toString())));
          }
          return [];
        },
      );
      await ds.start(testing.Context());
      expect(ds.information(testing.Context()), '1 - 10 of 10');
      expect(ds.length, 10);
      await ds.refresh(testing.Context());
      await ds.nextPage(testing.Context());
      expect(ds.information(testing.Context()), '11 - 20 of 20');
      expect(ds.length, 20);
      await ds.refresh(testing.Context());
      expect(ds.length, 22);
      //refresh will goto page 0, so we need 2 next page
      await ds.nextPage(testing.Context());
      await ds.nextPage(testing.Context());
      expect(ds.information(testing.Context()), '21 - 22 of 22');

      await ds.gotoPage(testing.Context(), 0);
      expect(ds.information(testing.Context()), '1 - 10 of 22');

      await ds.gotoPage(testing.Context(), 1);
      expect(ds.information(testing.Context()), '11 - 20 of 22');

      await ds.gotoPage(testing.Context(), 2);
      expect(ds.information(testing.Context()), '21 - 22 of 22');
    });

    test('should set rows per page', () async {
      int step = 0;
      bool? lastIsRefresh;
      int? lastLimit;
      String? lastAnchorId;
      final ds = PagedTable<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          lastIsRefresh = isRefresh;
          lastLimit = limit;
          lastAnchorId = anchorId;
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person(entity: pb.Entity(id: 'init' + index.toString())));
          }
          if (step == 1) {
            // first more
            step++;
            return List.generate(
                limit, (index) => sample.Person(entity: pb.Entity(id: 'firstRefresh' + index.toString())));
          }
          if (step == 2) {
            // second refresh
            step++;
            return List.generate(
                2, (index) => sample.Person(entity: pb.Entity(id: 'secondRefresh' + index.toString())));
          }
          return [];
        },
      );
      await ds.start(testing.Context());
      expect(ds.length, 10);
      expect(ds.rowsPerPage, 10);
      expect(lastIsRefresh, true);
      expect(lastLimit, 10);
      expect(lastAnchorId, isNull);

      await ds.refresh(testing.Context());
      await ds.setRowsPerPage(testing.Context(), 20);
      expect(ds.rowsPerPage, 20);
      expect(lastIsRefresh, true);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'init0');
      expect(ds.length, 20);

      lastIsRefresh = null;
      lastLimit = null;
      lastAnchorId = null;
      await ds.setRowsPerPage(testing.Context(), 10);
      expect(ds.rowsPerPage, 10);
      expect(lastIsRefresh, isNull);
      expect(lastLimit, isNull);
      expect(lastAnchorId, isNull);
      expect(ds.length, 20);

      await ds.gotoPage(testing.Context(), 1);
      expect(ds.pageIndex, 1);
      expect(lastIsRefresh, isNull);
      expect(lastLimit, isNull);
      expect(lastAnchorId, isNull);

      await ds.refresh(testing.Context());
      await ds.setRowsPerPage(testing.Context(), 30);
      expect(ds.rowsPerPage, 30);
      expect(lastIsRefresh, true);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'firstRefresh0');
      expect(ds.length, 22);
      expect(ds.noMoreData, true);
    });
  });
}
