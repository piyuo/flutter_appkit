// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'continuous_full_view.dart';
import 'dataset_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[continuous_full_view]', () {
    test('should refresh on start', () async {
      int refreshCount = 0;
      ContinuousFullView view = ContinuousFullView(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async {
          int limit = 10;
          if (refreshCount == 1) {
            limit = 2;
          }
          refreshCount++;
          return List.generate(limit, (i) => sample.Person());
        },
      );
      await view.load(testing.Context());
      await view.refresh(testing.Context());

      // should read 10 rows
      expect(view.length, 10);
      expect(view.displayRows.length, 10);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);

      // should read 2 rows and display all
      await view.refresh(testing.Context());
      expect(view.length, 12);
      expect(view.displayRows.length, 12);
      expect(view.isEmpty, false);
      expect(view.isNotEmpty, true);
    });

    test('should remove duplicate data when refresh', () async {
      final ds = ContinuousFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test2',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async => [sample.Person()],
      );
      await ds.load(testing.Context());
      await ds.refresh(testing.Context());
      // second refresh will delete duplicate data
      expect(ds.length, 1);
    });

    test('should not reset on refresh', () async {
      final view = ContinuousFullView<sample.Person>(
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

      final view = ContinuousFullView<sample.Person>(
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
      final view = ContinuousFullView<sample.Person>(
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
      final view2 = ContinuousFullView<sample.Person>(
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
      final view = ContinuousFullView<sample.Person>(
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
      final cs2 = ContinuousFullView<sample.Person>(
        DatasetRam(dataBuilder: () => sample.Person()),
        id: 'test',
        dataBuilder: () => sample.Person(),
        loader: (context, _, __, anchorTimestamp, anchorId) async => [],
      );
      await cs2.load(testing.Context());
      expect(view.length, 1);
      expect(view.rowsPerPage, 10);
    });
  });
}
