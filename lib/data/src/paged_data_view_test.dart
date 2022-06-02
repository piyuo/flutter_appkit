// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/database/database.dart' as database;
import 'data_view.dart';
import 'paged_data_view.dart';
import 'dataset_ram.dart';

class OrderSampleDataView extends PagedDataView<sample.Person> {
  OrderSampleDataView()
      : super(
          DatasetRam(dataBuilder: () => sample.Person()),
          dataBuilder: () => sample.Person(),
          loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
            loaderIsRefresh = isRefresh;
            loaderLimit = limit;
            return List.generate(returnCount, (i) => sample.Person(entity: pb.Entity(id: '$returnID-$i')));
          },
        );

  static String returnID = 'A';

  static int returnCount = 10;

  static bool loaderIsRefresh = false;

  static int loaderLimit = 0;
}

void main() {
  setUpAll(() async {
    await database.initForTest();
  });

  setUp(() async {});

  tearDownAll(() async {});

  group('[paged_data_view]', () {
    test('should refresh', () async {
      OrderSampleDataView.returnCount = 10;
      OrderSampleDataView.returnID = 'A';
      final dataView = OrderSampleDataView();
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      // should read 10 rows
      expect(dataView.length, 10);
      expect(dataView.displayRows.length, 10);
      expect(dataView.isDisplayRowsFullPage, true);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);

      OrderSampleDataView.returnCount = 2;
      OrderSampleDataView.returnID = 'B';
      await dataView.refresh(testing.Context());
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
      await dateView.load(testing.Context());
      await dateView.refresh(testing.Context());
      expect(OrderSampleDataView.loaderIsRefresh, true);
      expect(OrderSampleDataView.loaderLimit, 10);
      expect(dateView.noMore, true);
    });

    test('should check no more data', () async {
      OrderSampleDataView.returnCount = 10;
      OrderSampleDataView.loaderIsRefresh = false;
      OrderSampleDataView.loaderLimit = 0;
      final dataView = OrderSampleDataView();
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.noMore, false);
      // know no more data at first
      OrderSampleDataView.returnCount = 9;
      final dataView2 = OrderSampleDataView();
      await dataView2.load(testing.Context());
      await dataView2.refresh(testing.Context());
      expect(dataView2.noMore, true);
    });

    test('should reset on refresh', () async {
      OrderSampleDataView.returnCount = 10;
      final dataView = OrderSampleDataView();
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.noMore, false);
      expect(dataView.length, 10);
      final result = await dataView.refresh(testing.Context());
      expect(result, true);
      expect(dataView.noMore, false);
      expect(dataView.length, 10);
    });

    test('should remove duplicate data when refresh', () async {
      final ds = PagedDataView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async =>
            [sample.Person(entity: pb.Entity(id: 'duplicate'))],
      );
      await ds.load(testing.Context());
      await ds.refresh(testing.Context());
      // second refresh will delete duplicate data
      expect(ds.length, 1);
    });

    test('should keep more and cache when receive enough data', () async {
      int refreshCount = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (refreshCount == 0) {
            refreshCount++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: index.toString(),
                      ),
                    ));
          }
          return List.generate(
              limit,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: 'more' + index.toString(),
                    ),
                  ));
        },
      );
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.noMore, false);
      expect(dataView.displayRows.length, 10);
      // second refresh will trigger reset
      await dataView.more(testing.Context(), 2);
      expect(dataView.noMore, false);
      expect(dataView.length, 12);
      expect(dataView.displayRows.length, 10);
    });

    test('should no keep more when receive less data', () async {
      int refreshCount = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (refreshCount == 0) {
            refreshCount++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: index.toString(),
                      ),
                    ));
          }
          return List.generate(
              1,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: 'more' + index.toString(),
                    ),
                  ));
        },
      );
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.noMore, false);
      // second refresh will trigger reset
      await dataView.more(testing.Context(), 2);
      expect(dataView.noMore, true);
      expect(dataView.length, 11);
    });

    test('should send anchor to data loader', () async {
      int idCount = 0;
      bool? _isRefresh;
      int? _limit;
      google.Timestamp? _anchorTimestamp;
      String? _anchorId;

      final dataView = PagedDataView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          _isRefresh = isRefresh;
          _limit = limit;
          _anchorTimestamp = anchorTimestamp;
          _anchorId = anchorId;
          idCount++;
          return List.generate(
              limit,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: idCount.toString(),
                      updateTime: DateTime.now().utcTimestamp,
                    ),
                  ));
        },
      );
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(_isRefresh, true);
      expect(_limit, 10);
      expect(_anchorTimestamp, isNull);
      expect(_anchorId, isNull);

      await dataView.more(testing.Context(), 1);
      expect(_isRefresh, false);
      expect(_limit, 1);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '1');

      await dataView.more(testing.Context(), 1);
      expect(_isRefresh, false);
      expect(_limit, 1);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '2');

      await dataView.refresh(testing.Context());
      expect(_isRefresh, true);
      expect(_limit, 10);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '1');
    });

    test('should no more on when receive empty data', () async {
      int moreCount = 0;
      int counter = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (counter == 0) {
            counter++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: index.toString(),
                        updateTime: DateTime.now().utcTimestamp,
                      ),
                    ));
          }
          moreCount++;
          return [];
        },
      );
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.noMore, false);

      await dataView.more(testing.Context(), 1);
      expect(dataView.noMore, true);
      expect(moreCount, 1);

      await dataView.more(testing.Context(), 1);
      expect(dataView.noMore, true);
      expect(moreCount, 1);
    });

    test('should no more on less data', () async {
      int moreCount = 0;
      int counter = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (counter == 0) {
            counter++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: index.toString(),
                        updateTime: DateTime.now().utcTimestamp,
                      ),
                    ));
          }
          moreCount++;
          return List.generate(
              1,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: index.toString(),
                      updateTime: DateTime.now().utcTimestamp,
                    ),
                  ));
        },
      );
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.noMore, false);

      await dataView.more(testing.Context(), 2);
      expect(dataView.noMore, true);
      expect(moreCount, 1);

      await dataView.more(testing.Context(), 2);
      expect(dataView.noMore, true);
      expect(moreCount, 1);
    });

    test('should select rows', () async {
      DataView dataView = PagedDataView(
        DatasetRam(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(10, (i) => sample.Person(entity: pb.Entity(id: '$i')));
        },
      );
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.displayRows.length, 10);
      expect(dataView.selectedRows.length, 0);
      dataView.selectRows([sample.Person(entity: pb.Entity(id: '5'))]);
      expect(dataView.selectedRows.length, 1);
      dataView.selectRows([]);
      expect(dataView.selectedRows.length, 0);

      dataView.selectRow(dataView.displayRows.first, true);
      expect(dataView.selectedRows.length, 1);
      expect(dataView.isRowSelected(dataView.displayRows.first), true);
      dataView.selectRow(dataView.displayRows.first, false);
      expect(dataView.selectedRows.length, 0);
      expect(dataView.isRowSelected(dataView.displayRows.first), false);
    });

    test('should fill display rows', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      final dataView = PagedDataView<sample.Person>(
        dataset,
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(10, (i) => sample.Person(entity: pb.Entity(id: '$i')));
        },
      );
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      await dataset.setRowsPerPage(testing.Context(), 5);
      dataView.pageIndex = 0;

      await dataView.fill();
      expect(dataView.displayRows.length, 5);
    });

    test('should load next/prev/last/first page', () async {
      int step = 0;
      final dataView = PagedDataView<sample.Person>(
        DatasetRam<sample.Person>(dataBuilder: () => sample.Person()),
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
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.isFirstPage, true);
      expect(dataView.hasPrevPage, false);
      expect(dataView.hasNextPage, true);
      expect(dataView.displayRows.length, 10);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);
      expect(dataView.noMore, false);
      expect(dataView.pageIndex, 0);
      expect(dataView.length, 10);

      await dataView.nextPage(testing.Context());
      expect(dataView.isFirstPage, false);
      expect(dataView.hasPrevPage, true);
      expect(dataView.hasNextPage, false);
      expect(dataView.displayRows.length, 2);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);
      expect(dataView.noMore, true);
      expect(dataView.pageIndex, 1);
      expect(dataView.length, 12);

      await dataView.prevPage(testing.Context());
      expect(dataView.hasPrevPage, false);
      expect(dataView.hasNextPage, true);
      expect(dataView.displayRows.length, 10);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);
      expect(dataView.noMore, true);
      expect(dataView.pageIndex, 0);
      expect(dataView.length, 12);

      await dataView.refresh(testing.Context());
      expect(dataView.hasPrevPage, false);
      expect(dataView.hasNextPage, true);
      expect(dataView.displayRows.length, 10);
      expect(dataView.isEmpty, false);
      expect(dataView.isNotEmpty, true);
      expect(dataView.noMore, true);
      expect(dataView.pageIndex, 0);
      expect(dataView.length, 14);

      await dataView.refresh(testing.Context());
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
        DatasetRam<sample.Person>(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person(entity: pb.Entity(id: 'init' + index.toString())));
          }
          if (step == 1) {
            // first more
            step++;
            return List.generate(
                limit, (index) => sample.Person(entity: pb.Entity(id: 'firstMore' + index.toString())));
          }
          if (step == 2) {
            // second more
            step++;
            return List.generate(2, (index) => sample.Person(entity: pb.Entity(id: 'secondMore' + index.toString())));
          }
          return [];
        },
      );
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.pageInfo(testing.Context()), '1 - 10 of many');
      expect(dataView.length, 10);
      await dataView.nextPage(testing.Context());
      expect(dataView.pageInfo(testing.Context()), '11 - 20 of many');
      expect(dataView.length, 20);
      await dataView.nextPage(testing.Context());
      expect(dataView.pageInfo(testing.Context()), '21 - 22 of 22');
      expect(dataView.length, 22);

      await dataView.gotoPage(testing.Context(), 0);
      expect(dataView.pageInfo(testing.Context()), '1 - 10 of 22');

      await dataView.gotoPage(testing.Context(), 1);
      expect(dataView.pageInfo(testing.Context()), '11 - 20 of 22');

      await dataView.gotoPage(testing.Context(), 2);
      expect(dataView.pageInfo(testing.Context()), '21 - 22 of 22');
    });

    test('should change when rows per page changed', () async {
      int step = 0;
      bool? lastIsRefresh;
      int? lastLimit;
      String? lastAnchorId;
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      final dataView = PagedDataView<sample.Person>(
        dataset,
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
                limit, (index) => sample.Person(entity: pb.Entity(id: 'firstMore' + index.toString())));
          }
          if (step == 2) {
            // second refresh
            step++;
            return List.generate(2, (index) => sample.Person(entity: pb.Entity(id: 'secondMore' + index.toString())));
          }
          return [];
        },
      );
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.length, 10);
      expect(dataView.rowsPerPage, 10);
      expect(lastIsRefresh, true);
      expect(lastLimit, 10);
      expect(lastAnchorId, isNull);

      await dataset.setRowsPerPage(testing.Context(), 20);
      expect(dataView.rowsPerPage, 20);
      expect(lastIsRefresh, false);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'init9');
      expect(dataView.length, 20);

      lastIsRefresh = null;
      lastLimit = null;
      lastAnchorId = null;
      await dataset.setRowsPerPage(testing.Context(), 10);
      expect(dataView.rowsPerPage, 10);
      expect(lastIsRefresh, isNull);
      expect(lastLimit, isNull);
      expect(lastAnchorId, isNull);
      expect(dataView.length, 20);

      await dataView.gotoPage(testing.Context(), 1);
      expect(dataView.pageIndex, 1);
      expect(lastIsRefresh, isNull);
      expect(lastLimit, isNull);
      expect(lastAnchorId, isNull);

      await dataset.setRowsPerPage(testing.Context(), 30);
      expect(dataView.rowsPerPage, 30);
      expect(lastIsRefresh, false);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'firstMore9');
      expect(dataView.length, 22);
      expect(dataView.noMore, true);
    });
  });
}
