// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/google/google.dart' as google;
import 'paged_full_view.dart';
import 'dataset_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[paged_full_view]', () {
    test('should refresh on start', () async {
      int refreshCount = 0;
      PagedFullView view = PagedFullView(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          int limit = 10;
          if (refreshCount == 1) {
            limit = 2;
          }
          refreshCount++;
          return List.generate(limit, (i) => sample.Person()..id = '$refreshCount$i');
        },
      );
      await view.load(testing.Context());
      await view.refresh(testing.Context());

      // should read 10 rows
      expect(view.length, 10);
      expect(view.displayRows.length, 10);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);

      // should read 2 rows
      await view.refresh(testing.Context());
      expect(view.length, 12);
      expect(view.displayRows.length, 10);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);
    });

    test('should remove duplicate data when refresh', () async {
      final view = PagedFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test2',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async => [sample.Person()..id = 'duplicate'],
      );
      await view.load(testing.Context());
      await view.refresh(testing.Context());
      // second refresh will delete duplicate data
      expect(view.length, 1);
    });

    test('should not reset on refresh', () async {
      final view = PagedFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          return List.generate(10, (index) => sample.Person());
        },
      );
      await view.load(testing.Context());
      await view.refresh(testing.Context());
      expect(view.noMore, true);
      expect(view.length, 10);
      await view.refresh(testing.Context());
      expect(view.noMore, true);
      expect(view.length, 20);
    });

    test('should send anchor to refresher', () async {
      int idCount = 0;
      int? _limit;
      google.Timestamp? _anchorTimestamp;
      String? _anchorId;

      final view = PagedFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          _limit = 10;
          _anchorTimestamp = anchorTimestamp;
          _anchorId = anchorId;
          idCount++;
          return List.generate(10, (index) => sample.Person()..id = idCount.toString());
        },
      );
      await view.load(testing.Context());
      await view.refresh(testing.Context());
      expect(_limit, 10);
      expect(_anchorTimestamp, isNull);
      expect(_anchorId, isNull);

      await view.refresh(testing.Context());
      expect(_limit, 10);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '1');
    });

    test('should save state', () async {
      final view = PagedFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          return [sample.Person()..id = 'only'];
        },
      );
      await view.load(testing.Context());
      await view.refresh(testing.Context());
      expect(view.length, 1);
      expect(view.rowsPerPage, 10);
      final view2 = PagedFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async => [],
      );
      await view2.load(testing.Context());
      await view2.refresh(testing.Context());
      expect(view.length, 1);
      expect(view.rowsPerPage, 10);
    });

    test('should goto page', () async {
      final view = PagedFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          return [sample.Person()];
        },
      );
      await view.load(testing.Context());
      await view.refresh(testing.Context());
      expect(view.length, 1);
      expect(view.rowsPerPage, 10);
      final view2 = PagedFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async => [],
      );
      await view2.load(testing.Context());
      await view2.refresh(testing.Context());
      expect(view.length, 1);
      expect(view.rowsPerPage, 10);
    });

    test('should load next/prev/last/first page', () async {
      int step = 0;
      final view = PagedFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person());
          }
          if (step == 1) {
            // next page
            step++;
            return List.generate(2, (index) => sample.Person());
          }
          if (step == 2) {
            // refresh
            step++;
            return List.generate(2, (index) => sample.Person());
          }
          return [];
        },
      );
      await view.load(testing.Context());
      await view.refresh(testing.Context());
      expect(view.hasPrevPage, false);
      expect(view.hasNextPage, false);
      expect(view.displayRows.length, 10);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);
      expect(view.noMore, true);
      expect(view.pageIndex, 0);
      expect(view.length, 10);

      await view.refresh(testing.Context());
      await view.nextPage(testing.Context());
      expect(view.hasPrevPage, true);
      expect(view.hasNextPage, false);
      expect(view.displayRows.length, 2);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);
      expect(view.noMore, true);
      expect(view.pageIndex, 1);
      expect(view.length, 12);

      await view.prevPage(testing.Context());
      expect(view.hasPrevPage, false);
      expect(view.hasNextPage, true);
      expect(view.displayRows.length, 10);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);
      expect(view.noMore, true);
      expect(view.pageIndex, 0);
      expect(view.length, 12);

      await view.refresh(testing.Context());
      expect(view.hasPrevPage, false);
      expect(view.hasNextPage, true);
      expect(view.displayRows.length, 10);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);
      expect(view.noMore, true);
      expect(view.pageIndex, 0);
      expect(view.length, 14);

      await view.refresh(testing.Context());
      expect(view.hasPrevPage, false);
      expect(view.hasNextPage, true);
      expect(view.displayRows.length, 10);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);
      expect(view.noMore, true);
      expect(view.pageIndex, 0);
      expect(view.length, 14);
    });

    test('should goto page and show info', () async {
      int step = 0;
      final view = PagedFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person());
          }
          if (step == 1) {
            // first refresh
            step++;
            return List.generate(limit, (index) => sample.Person());
          }
          if (step == 2) {
            // second refresh
            step++;
            return List.generate(2, (index) => sample.Person());
          }
          return [];
        },
      );
      await view.load(testing.Context());
      await view.refresh(testing.Context());
      expect(view.pageInfo(testing.Context()), '1 - 10 of 10');
      expect(view.length, 10);
      await view.refresh(testing.Context());
      await view.nextPage(testing.Context());
      expect(view.pageInfo(testing.Context()), '11 - 20 of 20');
      expect(view.length, 20);
      await view.refresh(testing.Context());
      expect(view.length, 22);
      //refresh will goto page 0, so we need 2 next page
      await view.nextPage(testing.Context());
      await view.nextPage(testing.Context());
      expect(view.pageInfo(testing.Context()), '21 - 22 of 22');

      await view.gotoPage(testing.Context(), 0);
      expect(view.pageInfo(testing.Context()), '1 - 10 of 22');

      await view.gotoPage(testing.Context(), 1);
      expect(view.pageInfo(testing.Context()), '11 - 20 of 22');

      await view.gotoPage(testing.Context(), 2);
      expect(view.pageInfo(testing.Context()), '21 - 22 of 22');
    });

    test('should set rows per page', () async {
      int step = 0;
      bool? lastIsRefresh;
      int? lastLimit;
      String? lastAnchorId;
      final dataset = DatasetRam(dataBuilder: () => sample.Person());
      final view = PagedFullView<sample.Person>(
        dataset,
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          lastIsRefresh = isRefresh;
          lastLimit = limit;
          lastAnchorId = anchorId;
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person()..id = 'init' + index.toString());
          }
          if (step == 1) {
            // first more
            step++;
            return List.generate(limit, (index) => sample.Person()..id = 'firstRefresh' + index.toString());
          }
          if (step == 2) {
            // second refresh
            step++;
            return List.generate(2, (index) => sample.Person()..id = 'secondRefresh' + index.toString());
          }
          return [];
        },
      );
      await view.load(testing.Context());
      await view.refresh(testing.Context());
      expect(view.length, 10);
      expect(view.rowsPerPage, 10);
      expect(lastIsRefresh, true);
      expect(lastLimit, 10);
      expect(lastAnchorId, isNull);

      await view.refresh(testing.Context());
      await dataset.setRowsPerPage(testing.Context(), 20);
      expect(view.rowsPerPage, 20);
      expect(lastIsRefresh, true);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'init0');
      expect(view.length, 20);

      lastIsRefresh = null;
      lastLimit = null;
      lastAnchorId = null;
      await dataset.setRowsPerPage(testing.Context(), 10);
      expect(view.rowsPerPage, 10);
      expect(lastIsRefresh, isNull);
      expect(lastLimit, isNull);
      expect(lastAnchorId, isNull);
      expect(view.length, 20);

      await view.gotoPage(testing.Context(), 1);
      expect(view.pageIndex, 1);
      expect(lastIsRefresh, isNull);
      expect(lastLimit, isNull);
      expect(lastAnchorId, isNull);

      await view.refresh(testing.Context());
      await dataset.setRowsPerPage(testing.Context(), 30);
      expect(view.rowsPerPage, 30);
      expect(lastIsRefresh, true);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'firstRefresh0');
      expect(view.length, 22);
      expect(view.noMore, true);
    });
  });
}
