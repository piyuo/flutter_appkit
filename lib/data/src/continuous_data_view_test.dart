// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/database/database.dart' as database;
import 'continuous_data_view.dart';
import 'dataset_ram.dart';

void main() {
  setUpAll(() async {
    await database.initForTest();
  });

  setUp(() async {});

  tearDownAll(() async {});

  group('[continuous_data_view]', () {
    test('should display all rows', () async {
      int step = 0;
      final ds = ContinuousDataView<sample.Person>(
        DatasetRam<sample.Person>(dataBuilder: () => sample.Person()),
        dataBuilder: () => sample.Person(),
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person(entity: pb.Entity(id: 'init' + index.toString())));
          }
          if (step == 1) {
            // first nextPage
            step++;
            return List.generate(
                limit, (index) => sample.Person(entity: pb.Entity(id: 'firstMore' + index.toString())));
          }
          if (step == 2) {
            // second nextPage
            step++;
            return List.generate(2, (index) => sample.Person(entity: pb.Entity(id: 'secondMore' + index.toString())));
          }
          if (step == 3) {
            // first more
            step++;
            return List.generate(3, (index) => sample.Person(entity: pb.Entity(id: 'secondMore' + index.toString())));
          }
          return [];
        },
      );
      await ds.load(testing.Context());
      expect(ds.pageInfo(testing.Context()), '1 - 10 of many');
      expect(ds.length, 10);
      await ds.refresh(testing.Context()); // first nextPage, it will reset dataset cause download rows is rowsPerPage
      expect(ds.pageInfo(testing.Context()), '1 - 10 of many');
      expect(ds.length, 10);
      await ds.refresh(testing.Context()); // second nextPage, it will add to dataset
      expect(ds.pageInfo(testing.Context()), '1 - 12 of many');
      expect(ds.length, 12);
    });

    test('should fill display rows when load more', () async {
      int step = 0;
      final ds = ContinuousDataView<sample.Person>(
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
          return [];
        },
      );
      await ds.load(testing.Context());
      expect(ds.pageInfo(testing.Context()), '1 - 10 of many');
      expect(ds.length, 10);
      expect(ds.displayRows.length, 10);
      await ds.more(testing.Context(), 10);
      expect(ds.pageInfo(testing.Context()), '1 - 20 of many');
      expect(ds.length, 20);
      expect(ds.displayRows.length, 20);
      await ds.more(testing.Context(), 10);
      expect(ds.pageInfo(testing.Context()), '1 - 20 of 20');
    });
  });

  test('should refresh after load more', () async {
    int step = 0;
    final ds = ContinuousDataView<sample.Person>(
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
          return List.generate(limit, (index) => sample.Person(entity: pb.Entity(id: 'firstMore' + index.toString())));
        }
        if (step == 2) {
          // refresh
          step++;
          return List.generate(2, (index) => sample.Person(entity: pb.Entity(id: 'firstRefresh' + index.toString())));
        }
        return [];
      },
    );
    await ds.load(testing.Context());
    expect(ds.pageInfo(testing.Context()), '1 - 10 of many');
    expect(ds.length, 10);
    expect(ds.displayRows.length, 10);
    await ds.more(testing.Context(), 10);
    expect(ds.pageInfo(testing.Context()), '1 - 20 of many');
    expect(ds.length, 20);
    expect(ds.displayRows.length, 20);
    await ds.refresh(testing.Context());
    expect(ds.pageInfo(testing.Context()), '1 - 22 of many');
  });
}
