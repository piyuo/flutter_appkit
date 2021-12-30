// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'data_source.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'types.dart';

void main() {
  setUp(() async {});

  group('[data_source]', () {
    test('should load', () async {
      int refreshCount = 0;
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          if (refreshCount == 0) {
            // first
            refreshCount++;
            return List.generate(10, (index) => index.toString());
          }
          if (refreshCount == 1) {
            // second
            refreshCount++;
            return List.generate(10, (index) => index.toString());
          }
          if (refreshCount == 2) {
            // third
            refreshCount++;
            return List.generate(2, (index) => index.toString());
          }
          return []; // rest
        },
      );

      expect(sds.status, PagedDataSourceStatus.notLoad);
      // first
      await sds.loadMoreRow(testing.Context());
      expect(sds.length, 10);
      expect(sds.status, PagedDataSourceStatus.load);

      // second
      await sds.loadMoreRow(testing.Context(), to: 1);
      expect(sds.length, 20);
      expect(sds.status, PagedDataSourceStatus.load);

      // third
      await sds.loadMoreRow(testing.Context(), to: 2);
      expect(sds.length, 22);
      expect(sds.status, PagedDataSourceStatus.end);

      // rest
      await sds.loadMoreRow(testing.Context(), to: 3);
      expect(sds.length, 22);
      expect(sds.status, PagedDataSourceStatus.end);

      // assert
      try {
        await sds.loadMoreRow(testing.Context(), to: -1);
      } catch (err) {
        expect(err, throwsAssertionError);
      }
    });

    test('should load on error', () async {
      int refreshCount = 0;
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          if (refreshCount == 0) {
            refreshCount++;
            throw Exception('my error');
          }
          if (refreshCount == 1) {
            return List.generate(3, (index) => index.toString());
          }
          return []; // rest
        },
      );

      expect(sds.status, PagedDataSourceStatus.notLoad);
      // first
      try {
        await sds.loadMoreRow(testing.Context());
      } catch (err) {
        expect(err, isNotNull);
      }
      expect(sds.status, PagedDataSourceStatus.notLoad);

      // second
      await sds.loadMoreRow(testing.Context());
      expect(sds.status, PagedDataSourceStatus.end);
      expect(sds.length, 3);
    });

    test('should delete rows', () async {
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          return ['a', 'b', 'c'];
        },
        dataComparator: (String src, String dest) {
          return src.compareTo(dest);
        },
      );
      await sds.loadMoreRow(testing.Context());
      sds.deleteRows(['b', 'c']);
      expect(sds.currentRows[0], 'a');
    });

    test('should refresh', () async {
      int refreshCount = 0;
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          return ['a', 'b', 'c'];
        },
        dataComparator: (String src, String dest) {
          return src.compareTo(dest);
        },
        dataRefresher: (BuildContext context, String? first, int rowsPerPage) async {
          if (refreshCount == 0) {
            //first
            refreshCount++;
            throw Exception('my error');
          }
          if (refreshCount == 1) {
            //second
            refreshCount++;
            return RefreshInstruction(
              updated: ['b', 'd'],
              deleted: ['c'],
            );
          }
          // third
          return RefreshInstruction(
            updated: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
            deleted: [],
          );
        },
      );

      expect(sds.status, PagedDataSourceStatus.notLoad);
      expect(sds.supportRefresh, false);
      await sds.loadMoreRow(testing.Context());
      expect(sds.supportRefresh, true); // refresh must after load
      // first
      try {
        await sds.refreshNewRow(testing.Context());
      } catch (err) {
        expect(err, isNotNull);
      }

      // second
      await sds.refreshNewRow(testing.Context());
      expect(sds.currentRows[0], 'b');
      expect(sds.currentRows[1], 'd');
      expect(sds.currentRows[2], 'a');
      expect(sds.status, PagedDataSourceStatus.end);

      // third
      await sds.refreshNewRow(testing.Context());
      expect(sds.status, PagedDataSourceStatus.load);
      expect(sds.length, 10);
    });

    test('should load next/prev/last/first page', () async {
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          if (last == null) {
            return List.generate(10, (index) => index.toString());
          }
          return List.generate(2, (index) => index.toString());
        },
      );

      expect(sds.hasFirstPage, false);
      expect(sds.hasPrevPage, false);
      expect(sds.hasNextPage, false);
      expect(sds.hasLastPage, false);

      // page 0
      await sds.loadMoreRow(testing.Context());
      expect(sds.isBusy, false);
      expect(sds.status, PagedDataSourceStatus.load);
      expect(sds.length, 10);
      expect(sds.pageCount, 1);
      expect(sds.currentPageIndex, 0);
      expect(sds.rowCount, 10);
      expect(sds.getRowCountByPage(0), 10);
      expect(sds.getRowCountByPage(1), 0);
      expect(sds.rowIndex(1), 1);
      expect(sds.getRowIndexByPage(0, 1), 1);
      expect(sds.row(1), '1');
      expect(sds.hasFirstPage, false);
      expect(sds.hasPrevPage, false);
      expect(sds.hasNextPage, true);
      expect(sds.hasLastPage, false);

      // page 1
      await sds.nextPage(testing.Context());
      expect(sds.isBusy, false);
      expect(sds.status, PagedDataSourceStatus.end);
      expect(sds.length, 12);
      expect(sds.pageCount, 2);
      expect(sds.currentPageIndex, 1);
      expect(sds.rowCount, 2);
      expect(sds.getRowCountByPage(0), 10);
      expect(sds.getRowCountByPage(1), 2);
      expect(sds.getRowCountByPage(2), 0);
      expect(sds.rowIndex(1), 11);
      expect(sds.getRowIndexByPage(1, 2), 12);
      expect(sds.row(1), '1');
      expect(sds.hasFirstPage, true);
      expect(sds.hasPrevPage, true);
      expect(sds.hasNextPage, false);
      expect(sds.hasLastPage, false);

      // page 0
      await sds.prevPage(testing.Context());
      expect(sds.isBusy, false);
      expect(sds.status, PagedDataSourceStatus.end);
      expect(sds.length, 12);
      expect(sds.pageCount, 2);
      expect(sds.currentPageIndex, 0);
      expect(sds.rowCount, 10);
      expect(sds.getRowCountByPage(0), 10);
      expect(sds.getRowCountByPage(1), 2);
      expect(sds.rowIndex(1), 1);
      expect(sds.getRowIndexByPage(0, 1), 1);
      expect(sds.getRowIndexByPage(1, 1), 11);
      expect(sds.row(1), '1');
      expect(sds.hasFirstPage, false);
      expect(sds.hasPrevPage, false);
      expect(sds.hasNextPage, true);
      expect(sds.hasLastPage, true);

      // page 1
      await sds.lastPage(testing.Context());
      expect(sds.currentPageIndex, 1);

      // page 0
      await sds.firstPage(testing.Context());
      expect(sds.currentPageIndex, 0);
    });

    test('should check isEmpty', () {
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          return [];
        },
      );
      expect(sds.pageCount, 1);
      expect(sds.isEmpty, true);
      expect(sds.isNotEmpty, false);
    });

    test('should load and set state end', () async {
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          return ['a', 'b'];
        },
      );
      await sds.loadMoreRow(testing.Context());
      expect(sds.status, PagedDataSourceStatus.end);
      expect(sds.length, 2);
      expect(sds.isBusy, false);
      expect(sds.pageCount, 1);
    });

    test('should load and set state load', () async {
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          return List.generate(10, (index) => index.toString());
        },
      );
      await sds.loadMoreRow(testing.Context());
      expect(sds.status, PagedDataSourceStatus.load);
      expect(sds.length, 10);
      expect(sds.isBusy, false);
      expect(sds.pageCount, 1);
    });

    test('should change rowsPerPage', () async {
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          if (last == null) {
            return List.generate(10, (index) => index.toString());
          }
          return List.generate(2, (index) => index.toString());
        },
      );
      await sds.loadMoreRow(testing.Context());
      expect(sds.rowsPerPage, 10);
      expect(sds.pageCount, 1);
      expect(sds.rowCount, 10);

      await sds.setRowsPerPage(testing.Context(), 20);
      expect(sds.rowsPerPage, 20);
      expect(sds.pageCount, 1);
      expect(sds.length, 12);
      expect(sds.rowCount, 12);
    });

    test('should change rowsPerPage when next page exists', () async {
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          if (last == null) {
            return List.generate(10, (index) => index.toString());
          }
          return List.generate(2, (index) => index.toString());
        },
      );
      await sds.loadMoreRow(testing.Context());

      await sds.nextPage(testing.Context());
      expect(sds.rowsPerPage, 10);
      expect(sds.pageCount, 2);
      expect(sds.getRowCountByPage(0), 10);
      expect(sds.getRowCountByPage(1), 2);

      await sds.setRowsPerPage(testing.Context(), 20);
      expect(sds.rowsPerPage, 20);
      expect(sds.pageCount, 1);
      expect(sds.length, 12);
      expect(sds.getRowCountByPage(0), 12);
    });

    test('should show paging info', () async {
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          if (last == null) {
            return List.generate(10, (index) => index.toString());
          }
          return List.generate(2, (index) => index.toString());
        },
      );
      expect(sds.pagingInfo(testing.Context()), isEmpty);

      await sds.loadMoreRow(testing.Context());
      expect(sds.pagingInfo(testing.Context()), '1 - 10 of many');

      await sds.loadMoreRow(testing.Context(), to: 1);
      expect(sds.pagingInfo(testing.Context()), '1 - 10 of 12');
    });

    test('should select row', () async {
      int refreshCount = 0;
      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          if (refreshCount == 0) {
            refreshCount++;
            return List.generate(10, (index) => index.toString());
          }
          return List.generate(2, (index) => index.toString());
        },
        dataRemover: (BuildContext context, List<String> removeList) async {
          return true;
        },
      );
      expect(sds.selectedRowsIsEmpty, true);
      expect(sds.selectedRowsLength, 0);

      await sds.loadMoreRow(testing.Context());
      expect(sds.isSelected(0), false);
      sds.select(0, true);
      expect(sds.isSelected(0), true);
      expect(sds.selectedRowsIsEmpty, false);
      expect(sds.selectedRowsLength, 1);

      sds.select(0, false);
      expect(sds.isSelected(0), false);
      expect(sds.selectedRowsIsEmpty, true);
      expect(sds.selectedRowsLength, 0);

      sds.selectAll(true);
      expect(sds.isSelected(0), true);
      expect(sds.selectedRowsIsEmpty, false);
      expect(sds.selectedRowsLength, 10);

      expect(sds.supportRemove, true);
      await sds.deleteSelected(testing.Context());
      expect(sds.length, 2);
      expect(sds.status, PagedDataSourceStatus.end);
    });

    test('should use disk cache', () async {
      int refreshCount = 0;
      int saveCount = 0;
      CacheInstruction<String>? _instruction;

      diskCacheWriter(BuildContext context, CacheInstruction<String> instruction) async {
        saveCount++;
        _instruction = instruction;
      }

      diskCacheReader(BuildContext context) async {
        return _instruction!;
      }

      DataSource<String> sds = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          if (refreshCount == 0) {
            refreshCount++;
            return List.generate(10, (index) => index.toString());
          }
          return List.generate(2, (index) => index.toString());
        },
        dataComparator: (String src, String dest) {
          return src.compareTo(dest);
        },
        dataRefresher: (BuildContext context, String? first, int rowsPerPage) async {
          refreshCount++;
          return RefreshInstruction(
            updated: ['hi $refreshCount'],
            deleted: [],
          );
        },
        diskCacheReader: diskCacheReader,
        diskCacheWriter: diskCacheWriter,
      );

      await sds.loadMoreRow(testing.Context());
      expect(saveCount, 1);
      expect(_instruction, isNotNull);
      expect(_instruction!.rowsPerPage, 10);
      expect(_instruction!.status, PagedDataSourceStatus.load);
      expect(sds.pageCount, 1);

      await sds.loadMoreRow(testing.Context(), to: 1);
      expect(saveCount, 2);
      expect(_instruction!.rows.length, 12);
      expect(_instruction!.rowsPerPage, 10);
      expect(_instruction!.status, PagedDataSourceStatus.end);
      expect(sds.pageCount, 2);

      await sds.setRowsPerPage(testing.Context(), 20);
      expect(sds.pageCount, 1);
      expect(saveCount, 3);
      expect(_instruction!.rows.length, 12);
      expect(_instruction!.rowsPerPage, 20);
      expect(_instruction!.status, PagedDataSourceStatus.end);

      var loadCount2 = 0;
      var refreshCount2 = 0;
      DataSource<String> sds2 = DataSource(
        dataLoader: (BuildContext context, String? last, int length) async {
          loadCount2++;
          return [];
        },
        dataComparator: (String src, String dest) {
          return src.compareTo(dest);
        },
        dataRefresher: (BuildContext context, String? first, int rowsPerPage) async {
          refreshCount2++;
          return RefreshInstruction(
            updated: ['new'],
            deleted: [],
          );
        },
        diskCacheReader: diskCacheReader,
        diskCacheWriter: diskCacheWriter,
      );
      await sds2.init(testing.Context());
      expect(sds2.pageCount, 1);
      expect(loadCount2, 0);
      expect(refreshCount2, 1);
      expect(sds2.length, 13);
      expect(sds2.rowsPerPage, 20);
      expect(sds2.status, PagedDataSourceStatus.end);
    });
  });
}
