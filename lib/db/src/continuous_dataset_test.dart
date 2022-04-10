// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'db.dart';
import 'continuous_dataset.dart';
import 'memory_ram.dart';

void main() {
  setUpAll(() async {
    await initDBForTest();
  });

  setUp(() async {});

  tearDownAll(() async {});

  group('[continuous_dataset]', () {
    test('should display all rows', () async {
      int step = 0;
      final ds = ContinuousDataset<sample.Person>(
        MemoryRam<sample.Person>(dataBuilder: () => sample.Person()),
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
      await ds.start(testing.Context());
      expect(ds.information(testing.Context()), '10 of many');
      expect(ds.length, 10);
      await ds.refresh(testing.Context()); // first nextPage, it will reset memory cause download rows is rowsPerPage
      expect(ds.information(testing.Context()), '10 of many');
      expect(ds.length, 10);
      await ds.refresh(testing.Context()); // second nextPage, it will add to memory
      expect(ds.information(testing.Context()), '12 of many');
      expect(ds.length, 12);
    });

    test('should fill display rows when load more', () async {
      int step = 0;
      final ds = ContinuousDataset<sample.Person>(
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
          return [];
        },
      );
      await ds.start(testing.Context());
      expect(ds.information(testing.Context()), '10 of many');
      expect(ds.length, 10);
      expect(ds.displayRows.length, 10);
      await ds.more(testing.Context(), 10);
      expect(ds.information(testing.Context()), '20 of many');
      expect(ds.length, 20);
      expect(ds.displayRows.length, 20);
      await ds.more(testing.Context(), 10);
      expect(ds.information(testing.Context()), '20 rows');
    });
  });

  test('should refresh after load more', () async {
    int step = 0;
    final ds = ContinuousDataset<sample.Person>(
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
    await ds.start(testing.Context());
    expect(ds.information(testing.Context()), '10 of many');
    expect(ds.length, 10);
    expect(ds.displayRows.length, 10);
    await ds.more(testing.Context(), 10);
    expect(ds.information(testing.Context()), '20 of many');
    expect(ds.length, 20);
    expect(ds.displayRows.length, 20);
    await ds.refresh(testing.Context());
    expect(ds.information(testing.Context()), '22 of many');
  });
}
