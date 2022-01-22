// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'data_source.dart';

void main() {
  setUpAll(() async {
    await db.initForTest();
    await cache.initForTest();
  });

  setUp(() async {
    await cache.reset();
  });

  group('[data_source]', () {
    test('should load next/prev/last/first page', () async {
      int step = 0;
      final ds = DataSource<sample.Person>(
        id: 'ds1',
        dataBuilder: () => sample.Person(),
        dataLoader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'init' + index.toString(),
                      ),
                    ));
          }
          if (step == 1) {
            // next page
            step++;
            return List.generate(
                2,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'next' + index.toString(),
                      ),
                    ));
          }
          if (step == 2) {
            // refresh
            step++;
            return List.generate(
                2,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'refresh' + index.toString(),
                      ),
                    ));
          }
          if (step == 3) {
            step++;
            return null; // no need refresh
          }
        },
      );
      await ds.init(
        testing.Context(),
      );
      expect(ds.hasFirstPage, false);
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.hasLastPage, false);
      expect(ds.pageCount, 1);
      expect(ds.pageRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, false);
      expect(ds.pageIndex, 0);
      expect(ds.allRows.length, 10);
      expect(ds.isLastPage, false);
      expect(ds.currentIndexStart, 0);
      expect(ds.currentIndexEnd, ds.rowsPerPage);
      expect(ds.currentRowCount, ds.rowsPerPage);

      await ds.nextPage(testing.Context());
      expect(ds.hasFirstPage, true);
      expect(ds.hasPrevPage, true);
      expect(ds.hasNextPage, false);
      expect(ds.hasLastPage, false);
      expect(ds.pageCount, 2);
      expect(ds.pageRows.length, 2);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, true);
      expect(ds.pageIndex, 1);
      expect(ds.allRows.length, 12);
      expect(ds.isLastPage, true);
      expect(ds.currentIndexStart, 10);
      expect(ds.currentIndexEnd, 12);
      expect(ds.currentRowCount, 2);

      await ds.prevPage(testing.Context());
      expect(ds.hasFirstPage, false);
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.hasLastPage, true);
      expect(ds.pageCount, 2);
      expect(ds.pageRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, true);
      expect(ds.pageIndex, 0);
      expect(ds.allRows.length, 12);
      expect(ds.isLastPage, false);
      expect(ds.currentIndexStart, 0);
      expect(ds.currentIndexEnd, 10);
      expect(ds.currentRowCount, 10);

      await ds.refresh(testing.Context());
      expect(ds.hasFirstPage, false);
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.hasLastPage, true);
      expect(ds.pageCount, 2);
      expect(ds.pageRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, true);
      expect(ds.pageIndex, 0);
      expect(ds.allRows.length, 14);
      expect(ds.isLastPage, false);
      expect(ds.currentIndexStart, 0);
      expect(ds.currentIndexEnd, 10);
      expect(ds.currentRowCount, 10);

      await ds.refresh(testing.Context());
      expect(ds.hasFirstPage, false);
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.hasLastPage, true);
      expect(ds.pageCount, 2);
      expect(ds.pageRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noNeedRefresh, true);
      expect(ds.noMoreData, true);
      expect(ds.pageIndex, 0);
      expect(ds.allRows.length, 14);
      expect(ds.isLastPage, false);
      expect(ds.currentIndexStart, 0);
      expect(ds.currentIndexEnd, 10);
      expect(ds.currentRowCount, 10);
    });

    test('should select row', () async {
      int step = 0;
      final ds = DataSource<sample.Person>(
        id: 'ds1',
        dataBuilder: () => sample.Person(),
        dataLoader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'init' + index.toString(),
                      ),
                    ));
          }
          if (step == 1) {
            // next page
            step++;
            return List.generate(
                2,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'next' + index.toString(),
                      ),
                    ));
          }
        },
      );
      await ds.init(testing.Context());
      await ds.nextPage(testing.Context());
      expect(ds.selectedRows.length, 0);
      final row0 = ds.pageRows[0];
      final row1 = ds.pageRows[1];
      expect(ds.isRowSelected(row0), false);
      expect(ds.isRowSelected(row1), false);
      ds.selectRow(row0, true);
      expect(ds.isRowSelected(row0), true);
      ds.selectRow(row1, true);
      expect(ds.isRowSelected(row1), true);
      expect(ds.selectedRows.length, 2);
      ds.selectRow(row0, false);
      expect(ds.isRowSelected(row0), false);
      expect(ds.selectedRows.length, 1);
      ds.selectRow(row1, false);
      expect(ds.isRowSelected(row1), false);
      expect(ds.selectedRows.length, 0);

      ds.selectAllRows(true);
      expect(ds.selectedRows.length, 12);
      ds.selectAllRows(false);
      expect(ds.selectedRows.length, 0);

      ds.selectRows(true);
      expect(ds.selectedRows.length, 2);
      ds.selectRows(false);
      expect(ds.selectedRows.length, 0);
      ds.prevPage(testing.Context());
      ds.selectRows(true);
      expect(ds.selectedRows.length, 10);
      ds.selectRows(false);
      expect(ds.selectedRows.length, 0);
    });

    test('should goto page and show info', () async {
      int step = 0;
      final ds = DataSource<sample.Person>(
        id: 'ds1',
        dataBuilder: () => sample.Person(),
        dataLoader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'init' + index.toString(),
                      ),
                    ));
          }
          if (step == 1) {
            // first more
            step++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'firstMore' + index.toString(),
                      ),
                    ));
          }
          if (step == 2) {
            // second more
            step++;
            return List.generate(
                2,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'secondMore' + index.toString(),
                      ),
                    ));
          }
        },
      );
      await ds.init(
        testing.Context(),
      );
      expect(ds.pagingInfo(testing.Context()), '1 - 10 of many');
      expect(ds.allRows.length, 10);
      await ds.nextPage(testing.Context());
      expect(ds.pagingInfo(testing.Context()), '11 - 20 of many');
      expect(ds.allRows.length, 20);
      await ds.nextPage(testing.Context());
      expect(ds.pagingInfo(testing.Context()), '21 - 22 of 22');
      expect(ds.allRows.length, 22);
      expect(ds.getRowCountByPage(0), 10);
      expect(ds.getRowCountByPage(1), 10);
      expect(ds.getRowCountByPage(2), 2);
      expect(ds.getRowCountByPage(3), 0);

      await ds.gotoPage(testing.Context(), 0);
      expect(ds.pagingInfo(testing.Context()), '1 - 10 of 22');

      await ds.gotoPage(testing.Context(), 1);
      expect(ds.pagingInfo(testing.Context()), '11 - 20 of 22');

      await ds.gotoPage(testing.Context(), 2);
      expect(ds.pagingInfo(testing.Context()), '21 - 22 of 22');
    });

    test('should set rows per page', () async {
      int step = 0;
      bool? lastIsRefresh;
      int? lastLimit;
      String? lastAnchorId;
      final ds = DataSource<sample.Person>(
        id: 'ds1',
        dataBuilder: () => sample.Person(),
        dataLoader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          lastIsRefresh = isRefresh;
          lastLimit = limit;
          lastAnchorId = anchorId;
          if (step == 0) {
            // init
            step++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'init' + index.toString(),
                      ),
                    ));
          }
          if (step == 1) {
            // first more
            step++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'firstMore' + index.toString(),
                      ),
                    ));
          }
          if (step == 2) {
            // second refresh
            step++;
            return List.generate(
                2,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: 'secondMore' + index.toString(),
                      ),
                    ));
          }
        },
      );
      await ds.init(
        testing.Context(),
      );
      expect(ds.allRows.length, 10);
      expect(ds.rowsPerPage, 10);
      expect(lastIsRefresh, true);
      expect(lastLimit, 10);
      expect(lastAnchorId, isNull);

      await ds.setRowsPerPage(testing.Context(), 20);
      expect(ds.rowsPerPage, 20);
      expect(lastIsRefresh, false);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'init9');
      expect(ds.allRows.length, 20);

      lastIsRefresh = null;
      lastLimit = null;
      lastAnchorId = null;
      await ds.setRowsPerPage(testing.Context(), 10);
      expect(ds.rowsPerPage, 10);
      expect(lastIsRefresh, isNull);
      expect(lastLimit, isNull);
      expect(lastAnchorId, isNull);
      expect(ds.allRows.length, 20);

      await ds.gotoPage(testing.Context(), 1);
      expect(ds.pageIndex, 1);
      expect(lastIsRefresh, isNull);
      expect(lastLimit, isNull);
      expect(lastAnchorId, isNull);

      await ds.setRowsPerPage(testing.Context(), 30);
      expect(ds.rowsPerPage, 30);
      expect(lastIsRefresh, false);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'firstMore9');
      expect(ds.allRows.length, 22);
      expect(ds.noMoreData, true);
    });
  });
}
