// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/net/net.dart' as net;
import 'continuous_full_view.dart';
import 'dataset_ram.dart';

void main() {
  group('[data.continuous_full_view]', () {
    test('should refresh on start', () async {
      int refreshCount = 0;
      ContinuousFullView view = ContinuousFullView(
        DatasetRam(objectBuilder: () => sample.Person()),
        id: 'test',
        loader: (_, __, anchorTimestamp, anchorId) async {
          int limit = 10;
          if (refreshCount == 1) {
            limit = 2;
          }
          refreshCount++;
          return List.generate(limit, (i) => sample.Person());
        },
      );
      await view.load();
      await view.refresh();

      // should read 10 rows
      expect(view.length, 10);
      expect(view.displayRows.length, 10);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);

      // should read 2 rows and display all
      await view.refresh();
      expect(view.length, 12);
      expect(view.displayRows.length, 12);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);
    });

    test('should remove duplicate data when refresh', () async {
      final ds = ContinuousFullView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        id: 'test2',
        loader: (_, __, anchorTimestamp, anchorId) async => [sample.Person()],
      );
      await ds.load();
      await ds.refresh();
      // second refresh will delete duplicate data
      expect(ds.length, 1);
    });

    test('should not reset on refresh', () async {
      final view = ContinuousFullView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        id: 'test',
        loader: (_, __, anchorTimestamp, anchorId) async {
          return List.generate(10, (index) => sample.Person());
        },
      );
      await view.load();
      await view.refresh();
      expect(view.noMore, true);
      expect(view.length, 10);
      await view.refresh();
      expect(view.noMore, true);
      expect(view.length, 20);
    });

    test('should send anchor to refresher', () async {
      int idCount = 0;
      int? limitResult;
      google.Timestamp? anchorTimestampResult;
      String? anchorIdResult;

      final view = ContinuousFullView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        id: 'test',
        loader: (_, __, anchorTimestamp, anchorId) async {
          limitResult = 10;
          anchorTimestampResult = anchorTimestamp;
          anchorIdResult = anchorId;
          idCount++;
          return List.generate(10, (index) => sample.Person(m: net.Model(i: idCount.toString())));
        },
      );
      await view.load();
      await view.refresh();
      expect(limitResult, 10);
      expect(anchorTimestampResult, isNull);
      expect(anchorIdResult, isNull);

      await view.refresh();
      expect(limitResult, 10);
      expect(anchorTimestampResult, isNotNull);
      expect(anchorIdResult, '1');
    });

    test('should save state', () async {
      final view = ContinuousFullView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        id: 'test',
        loader: (_, __, anchorTimestamp, anchorId) async {
          return [sample.Person()];
        },
      );
      await view.load();
      await view.refresh();
      expect(view.length, 1);
      expect(view.rowsPerPage, 10);
      final view2 = ContinuousFullView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        id: 'test',
        loader: (_, __, anchorTimestamp, anchorId) async => [],
      );
      await view2.load();
      await view2.refresh();
      expect(view.length, 1);
      expect(view.rowsPerPage, 10);
    });

    test('should goto page', () async {
      final view = ContinuousFullView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        id: 'test',
        loader: (_, __, anchorTimestamp, anchorId) async {
          return [sample.Person()];
        },
      );
      await view.load();
      await view.refresh();
      expect(view.length, 1);
      expect(view.rowsPerPage, 10);
      final cs2 = ContinuousFullView<sample.Person>(
        DatasetRam(objectBuilder: () => sample.Person()),
        id: 'test',
        loader: (_, __, anchorTimestamp, anchorId) async => [],
      );
      await cs2.load();
      expect(view.length, 1);
      expect(view.rowsPerPage, 10);
    });
  });
}
