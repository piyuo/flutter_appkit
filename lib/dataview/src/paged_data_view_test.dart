// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/testing/testing.dart' as testing;
import 'data_view.dart';
import 'paged_data_view.dart';
import 'dataset_ram.dart';

class OrderSampleDataView extends PagedDataView<sample.Person> {
  OrderSampleDataView()
      : super(
          DatasetRam(objectBuilder: () => sample.Person()),
          loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
            loaderIsRefresh = isRefresh;
            loaderLimit = limit;
            return List.generate(returnCount, (i) => sample.Person());
          },
        );

  static String returnID = 'A';

  static int returnCount = 10;

  static bool loaderIsRefresh = false;

  static int loaderLimit = 0;
}

void main() {
  group('[data.paged_data_view]', () {
    test('should refresh', () async {
      OrderSampleDataView.returnCount = 10;
      OrderSampleDataView.returnID = 'A';
      final dataView = OrderSampleDataView();
      await dataView.load();
      await dataView.refresh();
      // should read 10 rows
      expect(dataView.length, 10);
      expect(dataView.displayRows.length, 10);
      expect(dataView.isDisplayRowsFullPage, true);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);

      OrderSampleDataView.returnCount = 2;
      OrderSampleDataView.returnID = 'B';
      await dataView.refresh();
      expect(dataView.length, 12);
      expect(dataView.displayRows.length, 10);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);
    });

    test('should no more when data loader less than limit', () async {
      OrderSampleDataView.returnCount = 0;
      OrderSampleDataView.loaderIsRefresh = false;
      OrderSampleDataView.loaderLimit = 0;
      final dateView = OrderSampleDataView();
      await dateView.load();
      await dateView.refresh();
      expect(OrderSampleDataView.loaderIsRefresh, true);
      expect(OrderSampleDataView.loaderLimit, 10);
      expect(dateView.noMore, true);
    });

    test('should check no more data', () async {
      OrderSampleDataView.returnCount = 10;
      OrderSampleDataView.loaderIsRefresh = false;
      OrderSampleDataView.loaderLimit = 0;
      final dataView = OrderSampleDataView();
      await dataView.load();
      await dataView.refresh();
      expect(dataView.noMore, false);
      // know no more data at first
      OrderSampleDataView.returnCount = 9;
      final dataView2 = OrderSampleDataView();
      await dataView2.load();
      await dataView2.refresh();
      expect(dataView2.noMore, true);
    });

    test('should reset on refresh', () async {
      OrderSampleDataView.returnCount = 10;
      final dataView = OrderSampleDataView();
      await dataView.load();
      await dataView.refresh();
      expect(dataView.noMore, false);
      expect(dataView.length, 10);
      final result = await dataView.refresh();
      expect(result, true);
      expect(dataView.noMore, false);
      expect(dataView.length, 10);
    });

    test('should remove duplicate data when refresh', () async {
      final ds = PagedDataView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async => [sample.Person()],
      );
      await ds.load();
      await ds.refresh();
      // second refresh will delete duplicate data
      expect(ds.length, 1);
    });

    test('should keep more and cache when receive enough data', () async {
      int refreshCount = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          if (refreshCount == 0) {
            refreshCount++;
            return List.generate(limit, (index) => sample.Person());
          }
          return List.generate(limit, (index) => sample.Person());
        },
      );
      await dataView.load();
      await dataView.refresh();
      expect(dataView.noMore, false);
      expect(dataView.displayRows.length, 10);
      // second refresh will trigger reset
      await dataView.more(2);
      expect(dataView.noMore, false);
      expect(dataView.length, 12);
      expect(dataView.displayRows.length, 10);
    });

    test('should no keep more when receive less data', () async {
      int refreshCount = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          if (refreshCount == 0) {
            refreshCount++;
            return List.generate(limit, (index) => sample.Person());
          }
          return List.generate(1, (index) => sample.Person());
        },
      );
      await dataView.load();
      await dataView.refresh();
      expect(dataView.noMore, false);
      // second refresh will trigger reset
      await dataView.more(2);
      expect(dataView.noMore, true);
      expect(dataView.length, 11);
    });

    test('should send anchor to data loader', () async {
      int idCount = 0;
      bool? isRefreshResult;
      int? limitResult;
      google.Timestamp? anchorTimestampResult;
      String? anchorIdResult;

      final dataView = PagedDataView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          isRefreshResult = isRefresh;
          limitResult = limit;
          anchorTimestampResult = anchorTimestamp;
          anchorIdResult = anchorId;
          idCount++;
          return List.generate(
            limit,
            (index) => sample.Person()..id = idCount.toString(),
          );
        },
      );
      await dataView.load();
      await dataView.refresh();
      expect(isRefreshResult, true);
      expect(limitResult, 10);
      expect(anchorTimestampResult, isNull);
      expect(anchorIdResult, isNull);

      await dataView.more(1);
      expect(isRefreshResult, false);
      expect(limitResult, 1);
      expect(anchorTimestampResult, isNotNull);
      expect(anchorIdResult, '1');

      await dataView.more(1);
      expect(isRefreshResult, false);
      expect(limitResult, 1);
      expect(anchorTimestampResult, isNotNull);
      expect(anchorIdResult, '2');

      await dataView.refresh();
      expect(isRefreshResult, true);
      expect(limitResult, 10);
      expect(anchorTimestampResult, isNotNull);
      expect(anchorIdResult, '1');
    });

    test('should no more on when receive empty data', () async {
      int moreCount = 0;
      int counter = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          if (counter == 0) {
            counter++;
            return List.generate(limit, (index) => sample.Person());
          }
          moreCount++;
          return [];
        },
      );
      await dataView.load();
      await dataView.refresh();
      expect(dataView.noMore, false);

      await dataView.more(1);
      expect(dataView.noMore, true);
      expect(moreCount, 1);

      await dataView.more(1);
      expect(dataView.noMore, true);
      expect(moreCount, 1);
    });

    test('should no more on less data', () async {
      int moreCount = 0;
      int counter = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          if (counter == 0) {
            counter++;
            return List.generate(limit, (index) => sample.Person());
          }
          moreCount++;
          return List.generate(1, (index) => sample.Person());
        },
      );
      await dataView.load();
      await dataView.refresh();
      expect(dataView.noMore, false);

      await dataView.more(2);
      expect(dataView.noMore, true);
      expect(moreCount, 1);

      await dataView.more(2);
      expect(dataView.noMore, true);
      expect(moreCount, 1);
    });

    test('should select rows', () async {
      DataView dataView = PagedDataView(
        DatasetRam(objectBuilder: () => sample.Person()),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(10, (i) => sample.Person()..id = '$i');
        },
      );
      await dataView.load();
      await dataView.refresh();
      expect(dataView.displayRows.length, 10);
      expect(dataView.selectedIDs.length, 0);
      dataView.setSelectedRows([sample.Person()..id = '5']);
      expect(dataView.selectedIDs.length, 1);
      dataView.setSelectedRows([]);
      expect(dataView.selectedIDs.length, 0);

      dataView.selectRow(dataView.displayRows.first, true);
      expect(dataView.selectedIDs.length, 1);
      expect(dataView.isRowSelected(dataView.displayRows.first), true);
      dataView.selectRow(dataView.displayRows.first, false);
      expect(dataView.selectedIDs.length, 0);
      expect(dataView.isRowSelected(dataView.displayRows.first), false);
    });

    test('should fill display rows', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      final dataView = PagedDataView<sample.Person>(
        dataset,
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(10, (i) => sample.Person());
        },
      );
      await dataView.load();
      await dataView.refresh();
      await dataset.setRowsPerPage(5);
      dataView.pageIndex = 0;

      await dataView.fill();
      expect(dataView.displayRows.length, 5);
    });

    test('should load next/prev/last/first page', () async {
      int step = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam<sample.Person>(objectBuilder: () => sample.Person()),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
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
      await dataView.load();
      await dataView.refresh();
      expect(dataView.isFirstPage, true);
      expect(dataView.hasPrevPage, false);
      expect(dataView.hasNextPage, true);
      expect(dataView.displayRows.length, 10);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);
      expect(dataView.noMore, false);
      expect(dataView.pageIndex, 0);
      expect(dataView.length, 10);

      await dataView.nextPage();
      expect(dataView.isFirstPage, false);
      expect(dataView.hasPrevPage, true);
      expect(dataView.hasNextPage, false);
      expect(dataView.displayRows.length, 2);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);
      expect(dataView.noMore, true);
      expect(dataView.pageIndex, 1);
      expect(dataView.length, 12);

      await dataView.prevPage();
      expect(dataView.hasPrevPage, false);
      expect(dataView.hasNextPage, true);
      expect(dataView.displayRows.length, 10);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);
      expect(dataView.noMore, true);
      expect(dataView.pageIndex, 0);
      expect(dataView.length, 12);

      await dataView.refresh();
      expect(dataView.hasPrevPage, false);
      expect(dataView.hasNextPage, true);
      expect(dataView.displayRows.length, 10);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);
      expect(dataView.noMore, true);
      expect(dataView.pageIndex, 0);
      expect(dataView.length, 14);

      await dataView.refresh();
      expect(dataView.hasPrevPage, false);
      expect(dataView.hasNextPage, true);
      expect(dataView.displayRows.length, 10);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);
      expect(dataView.noMore, true);
      expect(dataView.pageIndex, 0);
      expect(dataView.length, 14);
    });

    test('should goto page and show info', () async {
      int step = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam<sample.Person>(objectBuilder: () => sample.Person()),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person());
          }
          if (step == 1) {
            // first more
            step++;
            return List.generate(limit, (index) => sample.Person());
          }
          if (step == 2) {
            // second more
            step++;
            return List.generate(2, (index) => sample.Person());
          }
          return [];
        },
      );
      await dataView.load();
      await dataView.refresh();
      expect(dataView.pageInfo(testing.Context()), '1 - 10 of many');
      expect(dataView.length, 10);
      await dataView.nextPage();
      expect(dataView.pageInfo(testing.Context()), '11 - 20 of many');
      expect(dataView.length, 20);
      await dataView.nextPage();
      expect(dataView.pageInfo(testing.Context()), '21 - 22 of 22');
      expect(dataView.length, 22);

      await dataView.goto(0);
      expect(dataView.pageInfo(testing.Context()), '1 - 10 of 22');

      await dataView.goto(1);
      expect(dataView.pageInfo(testing.Context()), '11 - 20 of 22');

      await dataView.goto(2);
      expect(dataView.pageInfo(testing.Context()), '21 - 22 of 22');
    });

    test('should change when rows per page changed', () async {
      int step = 0;
      bool? lastIsRefresh;
      int? lastLimit;
      String? lastAnchorId;
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      final dataView = PagedDataView<sample.Person>(
        dataset,
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          lastIsRefresh = isRefresh;
          lastLimit = limit;
          lastAnchorId = anchorId;
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person()..id = 'init$index');
          }
          if (step == 1) {
            // first more
            step++;
            return List.generate(limit, (index) => sample.Person()..id = 'firstMore$index');
          }
          if (step == 2) {
            // second refresh
            step++;
            return List.generate(2, (index) => sample.Person()..id = 'secondMore$index');
          }
          return [];
        },
      );
      await dataView.load();
      await dataView.refresh();
      expect(dataView.length, 10);
      expect(dataView.rowsPerPage, 10);
      expect(lastIsRefresh, true);
      expect(lastLimit, 10);
      expect(lastAnchorId, isNull);

      await dataView.setRowsPerPage(20);
      expect(dataView.rowsPerPage, 20);
      expect(lastIsRefresh, false);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'init9');
      expect(dataView.length, 20);

      lastIsRefresh = null;
      lastLimit = null;
      lastAnchorId = null;
      await dataView.setRowsPerPage(10);
      expect(dataView.rowsPerPage, 10);
      expect(lastIsRefresh, isNull);
      expect(lastLimit, isNull);
      expect(lastAnchorId, isNull);
      expect(dataView.length, 20);

      await dataView.goto(1);
      await dataView.fill();
      expect(dataView.pageIndex, 1);
      expect(lastIsRefresh, isNull);
      expect(lastLimit, isNull);
      expect(lastAnchorId, isNull);

      await dataView.setRowsPerPage(30);
      expect(dataView.rowsPerPage, 30);
      expect(lastIsRefresh, false);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'firstMore9');
      expect(dataView.length, 22);
      expect(dataView.noMore, true);
    });
  });
}
