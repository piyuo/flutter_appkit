// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'db.dart';
import 'dataset.dart';
import 'paged_dataset.dart';
import 'memory_ram.dart';

class OrderSampleDataset extends PagedDataset<sample.Person> {
  OrderSampleDataset()
      : super(
          MemoryRam(dataBuilder: () => sample.Person()),
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
    await initDBForTest();
  });

  setUp(() async {});

  tearDownAll(() async {});

  group('[dataset]', () {
    test('should refresh on startup', () async {
      OrderSampleDataset.returnCount = 10;
      OrderSampleDataset.returnID = 'A';
      final ds = OrderSampleDataset();
      await ds.open(testing.Context());
      // should read 10 rows
      expect(ds.length, 10);
      expect(ds.displayRows.length, 10);
      expect(ds.isDisplayRowsFullPage, true);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);

      OrderSampleDataset.returnCount = 2;
      OrderSampleDataset.returnID = 'B';
      await ds.refresh(testing.Context());
      expect(ds.length, 12);
      expect(ds.displayRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      ds.dispose();
    });

    test('should no more when data loader less than limit', () async {
      OrderSampleDataset.returnCount = 0;
      OrderSampleDataset.loaderIsRefresh = false;
      OrderSampleDataset.loaderLimit = 0;
      final ds = OrderSampleDataset();
      await ds.open(testing.Context());
      expect(OrderSampleDataset.loaderIsRefresh, true);
      expect(OrderSampleDataset.loaderLimit, 10);
      expect(ds.noMore, true);
    });

    test('should check no more data', () async {
      OrderSampleDataset.returnCount = 10;
      OrderSampleDataset.loaderIsRefresh = false;
      OrderSampleDataset.loaderLimit = 0;
      final ds = OrderSampleDataset();
      await ds.open(testing.Context());
      expect(ds.noMore, false);
      // know no more data at first
      OrderSampleDataset.returnCount = 9;
      final ds2 = OrderSampleDataset();
      await ds2.open(testing.Context());
      expect(ds2.noMore, true);
    });

    test('should reset on refresh', () async {
      OrderSampleDataset.returnCount = 10;
      final ds = OrderSampleDataset();
      await ds.open(testing.Context());
      expect(ds.noMore, false);
      expect(ds.length, 10);
      final result = await ds.refresh(testing.Context());
      expect(result, true);
      expect(ds.noMore, false);
      expect(ds.length, 10);
    });

    test('should remove duplicate data when refresh', () async {
      final ds = PagedDataset<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async =>
            [sample.Person(entity: pb.Entity(id: 'duplicate'))],
      );
      await ds.open(testing.Context());
      await ds.refresh(testing.Context());
      // second refresh will delete duplicate data
      expect(ds.length, 1);
    });

    test('should keep more and cache when receive enough data', () async {
      int refreshCount = 0;
      final ds = PagedDataset<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
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
      await ds.open(testing.Context());
      expect(ds.noMore, false);
      expect(ds.displayRows.length, 10);
      // second refresh will trigger reset
      await ds.more(testing.Context(), 2);
      expect(ds.noMore, false);
      expect(ds.length, 12);
      expect(ds.displayRows.length, 10);
    });

    test('should no keep more when receive less data', () async {
      int refreshCount = 0;
      final ds = PagedDataset<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
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
      await ds.open(testing.Context());
      expect(ds.noMore, false);
      // second refresh will trigger reset
      await ds.more(testing.Context(), 2);
      expect(ds.noMore, true);
      expect(ds.length, 11);
    });

    test('should send anchor to data loader', () async {
      int idCount = 0;
      bool? _isRefresh;
      int? _limit;
      google.Timestamp? _anchorTimestamp;
      String? _anchorId;

      final ds = PagedDataset<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
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
      await ds.open(testing.Context());
      expect(_isRefresh, true);
      expect(_limit, 10);
      expect(_anchorTimestamp, isNull);
      expect(_anchorId, isNull);

      await ds.more(testing.Context(), 1);
      expect(_isRefresh, false);
      expect(_limit, 1);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '1');

      await ds.more(testing.Context(), 1);
      expect(_isRefresh, false);
      expect(_limit, 1);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '2');

      await ds.refresh(testing.Context());
      expect(_isRefresh, true);
      expect(_limit, 10);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '1');
    });

    test('should no more on when receive empty data', () async {
      int moreCount = 0;
      int counter = 0;
      final ds = PagedDataset<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
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
      await ds.open(testing.Context());
      expect(ds.noMore, false);

      await ds.more(testing.Context(), 1);
      expect(ds.noMore, true);
      expect(moreCount, 1);

      await ds.more(testing.Context(), 1);
      expect(ds.noMore, true);
      expect(moreCount, 1);
    });

    test('should no more on less data', () async {
      int moreCount = 0;
      int counter = 0;
      final ds = PagedDataset<sample.Person>(
        MemoryRam(dataBuilder: () => sample.Person()),
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
      await ds.open(testing.Context());
      expect(ds.noMore, false);

      await ds.more(testing.Context(), 2);
      expect(ds.noMore, true);
      expect(moreCount, 1);

      await ds.more(testing.Context(), 2);
      expect(ds.noMore, true);
      expect(moreCount, 1);
    });

    test('should select rows', () async {
      Dataset ds = PagedDataset(
        MemoryRam(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(10, (i) => sample.Person(entity: pb.Entity(id: '$i')));
        },
      );
      await ds.open(testing.Context());
      expect(ds.displayRows.length, 10);
      expect(ds.selectedRows.length, 0);
      ds.selectRows([sample.Person(entity: pb.Entity(id: '5'))]);
      expect(ds.selectedRows.length, 1);
      ds.selectRows([]);
      expect(ds.selectedRows.length, 0);

      ds.selectRow(ds.displayRows.first, true);
      expect(ds.selectedRows.length, 1);
      expect(ds.isRowSelected(ds.displayRows.first), true);
      ds.selectRow(ds.displayRows.first, false);
      expect(ds.selectedRows.length, 0);
      expect(ds.isRowSelected(ds.displayRows.first), false);
    });

    test('should fill display rows', () async {
      final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
      final ds = PagedDataset<sample.Person>(
        memory,
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(10, (i) => sample.Person(entity: pb.Entity(id: '$i')));
        },
      );
      await ds.open(testing.Context());
      await memory.setRowsPerPage(testing.Context(), 5);
      ds.pageIndex = 0;

      await ds.fill();
      expect(ds.displayRows.length, 5);
    });

    test('should load next/prev/last/first page', () async {
      int step = 0;
      final ds = PagedDataset<sample.Person>(
        MemoryRam<sample.Person>(dataBuilder: () => sample.Person()),
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
      await ds.open(testing.Context());
      expect(ds.isFirstPage, true);
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.displayRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noMore, false);
      expect(ds.pageIndex, 0);
      expect(ds.length, 10);

      await ds.nextPage(testing.Context());
      expect(ds.isFirstPage, false);
      expect(ds.hasPrevPage, true);
      expect(ds.hasNextPage, false);
      expect(ds.displayRows.length, 2);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noMore, true);
      expect(ds.pageIndex, 1);
      expect(ds.length, 12);

      await ds.prevPage(testing.Context());
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.displayRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noMore, true);
      expect(ds.pageIndex, 0);
      expect(ds.length, 12);

      await ds.refresh(testing.Context());
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.displayRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noMore, true);
      expect(ds.pageIndex, 0);
      expect(ds.length, 14);

      await ds.refresh(testing.Context());
      expect(ds.hasPrevPage, false);
      expect(ds.hasNextPage, true);
      expect(ds.displayRows.length, 10);
      expect(ds.isEmpty, false);
      expect(ds.isNotEmpty, true);
      expect(ds.noMore, true);
      expect(ds.pageIndex, 0);
      expect(ds.length, 14);
    });

    test('should goto page and show info', () async {
      int step = 0;
      final ds = PagedDataset<sample.Person>(
        MemoryRam<sample.Person>(dataBuilder: () => sample.Person()),
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
      await ds.open(testing.Context());
      expect(ds.pageInfo(testing.Context()), '1 - 10 of many');
      expect(ds.length, 10);
      await ds.nextPage(testing.Context());
      expect(ds.pageInfo(testing.Context()), '11 - 20 of many');
      expect(ds.length, 20);
      await ds.nextPage(testing.Context());
      expect(ds.pageInfo(testing.Context()), '21 - 22 of 22');
      expect(ds.length, 22);

      await ds.gotoPage(testing.Context(), 0);
      expect(ds.pageInfo(testing.Context()), '1 - 10 of 22');

      await ds.gotoPage(testing.Context(), 1);
      expect(ds.pageInfo(testing.Context()), '11 - 20 of 22');

      await ds.gotoPage(testing.Context(), 2);
      expect(ds.pageInfo(testing.Context()), '21 - 22 of 22');
    });

    test('should set rows per page', () async {
      int step = 0;
      bool? lastIsRefresh;
      int? lastLimit;
      String? lastAnchorId;
      final ds = PagedDataset<sample.Person>(
        MemoryRam<sample.Person>(dataBuilder: () => sample.Person()),
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
      await ds.open(testing.Context());
      expect(ds.length, 10);
      expect(ds.rowsPerPage, 10);
      expect(lastIsRefresh, true);
      expect(lastLimit, 10);
      expect(lastAnchorId, isNull);

      await ds.setRowsPerPage(testing.Context(), 20);
      expect(ds.rowsPerPage, 20);
      expect(lastIsRefresh, false);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'init9');
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

      await ds.setRowsPerPage(testing.Context(), 30);
      expect(ds.rowsPerPage, 30);
      expect(lastIsRefresh, false);
      expect(lastLimit, 10);
      expect(lastAnchorId, 'firstMore9');
      expect(ds.length, 22);
      expect(ds.noMore, true);
    });
  });
}
