// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/sample/sample.dart' as sample;
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
      final view = ContinuousDataView<sample.Person>(
        DatasetRam<sample.Person>(objectBuilder: () => sample.Person()),
        loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
          if (step == 0) {
            // init
            step++;
            return List.generate(limit, (index) => sample.Person());
          }
          if (step == 1) {
            // first nextPage
            step++;
            return List.generate(limit, (index) => sample.Person());
          }
          if (step == 2) {
            // second nextPage
            step++;
            return List.generate(2, (index) => sample.Person());
          }
          if (step == 3) {
            // first more
            step++;
            return List.generate(3, (index) => sample.Person());
          }
          return [];
        },
      );
      await view.load();
      await view.refresh();

      expect(view.pageInfo(testing.Context()), '1 - 10 of many');
      expect(view.length, 10);
      await view.refresh(); // first nextPage, it will reset dataset cause download rows is rowsPerPage
      expect(view.pageInfo(testing.Context()), '1 - 10 of many');
      expect(view.length, 10);
      await view.refresh(); // second nextPage, it will add to dataset
      expect(view.pageInfo(testing.Context()), '1 - 12 of many');
      expect(view.length, 12);
    });

    test('should fill display rows when load more', () async {
      int step = 0;
      final view = ContinuousDataView<sample.Person>(
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
          return [];
        },
      );
      await view.load();
      await view.refresh();
      expect(view.pageInfo(testing.Context()), '1 - 10 of many');
      expect(view.length, 10);
      expect(view.displayRows.length, 10);
      await view.more(10);
      expect(view.pageInfo(testing.Context()), '1 - 20 of many');
      expect(view.length, 20);
      expect(view.displayRows.length, 20);
      await view.more(10);
      expect(view.pageInfo(testing.Context()), '1 - 20 of 20');
    });
  });

  test('should refresh after load more', () async {
    int step = 0;
    final view = ContinuousDataView<sample.Person>(
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
          // refresh
          step++;
          return List.generate(2, (index) => sample.Person());
        }
        return [];
      },
    );
    await view.load();
    await view.refresh();
    expect(view.pageInfo(testing.Context()), '1 - 10 of many');
    expect(view.length, 10);
    expect(view.displayRows.length, 10);
    await view.more(10);
    expect(view.pageInfo(testing.Context()), '1 - 20 of many');
    expect(view.length, 20);
    expect(view.displayRows.length, 20);
    await view.refresh();
    expect(view.pageInfo(testing.Context()), '1 - 22 of many');
  });
}
