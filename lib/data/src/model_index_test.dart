// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'model_index.dart';

void main() {
  group('[data.model_index]', () {
    test('add should remove old before add', () async {
      final modelIndex = ModelIndex();
      final modelOld = pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp);
      await modelIndex.add(modelOld);

      expect(modelIndex[0].t.toDateTime().year, 2023);
      expect(modelIndex[0].t.toDateTime().day, 1);
      expect(modelIndex.length, 1);
      final modelNew = pb.Model(i: '1', t: DateTime(2023, 1, 2).timestamp);
      final added = await modelIndex.add(modelNew);
      expect(added, true);
      expect(modelIndex.length, 1);
      expect(modelIndex[0].t.toDateTime().year, 2023);
      expect(modelIndex[0].t.toDateTime().day, 2);
    });

    test('should not add if not newest', () async {
      final modelIndex = ModelIndex();
      final model = pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp);
      await modelIndex.add(model);
      expect(modelIndex[0].t.toDateTime().day, 1);
      expect(modelIndex.length, 1);
      final modelOld = pb.Model(i: '1', t: DateTime(2022, 1, 2).timestamp);
      final added = await modelIndex.add(modelOld);
      expect(added, false);
      expect(modelIndex.length, 1);
      expect(modelIndex[0].t.toDateTime().year, 2023);
      expect(modelIndex[0].t.toDateTime().day, 1);
    });

    test('should remove old before addAll', () async {
      final modelIndex = ModelIndex();
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      expect(modelIndex[0].t.toDateTime().day, 1);
      expect(modelIndex[1].t.toDateTime().day, 2);

      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 3).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 4).timestamp));
      expect(modelIndex.length, 2);
      expect(modelIndex[0].t.toDateTime().day, 3);
      expect(modelIndex[1].t.toDateTime().day, 4);
    });

    test('should sort by time', () async {
      final modelIndex = ModelIndex();
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 2, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      expect(modelIndex.length, 3);
      modelIndex.sort();
      expect(modelIndex[0].i, '2');
      expect(modelIndex[1].i, '3');
      expect(modelIndex[2].i, '1');
    });

    test('should sort by time desc', () async {
      final modelIndex = ModelIndex();
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 2, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      expect(modelIndex.length, 3);
      modelIndex.sort(desc: true);
      expect(modelIndex[0].i, '1');
      expect(modelIndex[1].i, '3');
      expect(modelIndex[2].i, '2');
    });

    test('should return true if already contains a model', () async {
      final modelIndex = ModelIndex();
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 2, 1).timestamp));
      expect(modelIndex.contains(pb.Model(i: '1', t: DateTime(2023, 2, 1).timestamp)), true);
      expect(modelIndex.contains(pb.Model(i: '2', t: DateTime(2023, 2, 1).timestamp)), false);
    });

    test('should return newest/oldest model id', () async {
      final modelIndex = ModelIndex();
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 2).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 4).timestamp));
      expect(modelIndex.newest!.i, '3');
      expect(modelIndex.oldest!.i, '2');
    });

    test('filter should return by page index', () async {
      final modelIndex = ModelIndex(rowsPerPage: 2);
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      await modelIndex.add(pb.Model(i: '4', t: DateTime(2023, 1, 4).timestamp));
      await modelIndex.add(pb.Model(i: '5', t: DateTime(2023, 1, 5).timestamp));
      expect(modelIndex.totalPages, 3);

      final view = modelIndex.filter(sortDesc: false).toList();
      expect(view.length, 2);
      expect(view[0].i, '1');
      expect(view[1].i, '2');

      final view2 = modelIndex.filter(sortDesc: false, pageIndex: 1).toList();
      expect(view2.length, 2);
      expect(view2[0].i, '3');
      expect(view2[1].i, '4');

      final view3 = modelIndex.filter(sortDesc: false, pageIndex: 2).toList();
      expect(view3.length, 1);
      expect(view3[0].i, '5');
    });

    test('filter should sort', () async {
      final modelIndex = ModelIndex();
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      await modelIndex.add(pb.Model(i: '4', t: DateTime(2023, 1, 4).timestamp));
      await modelIndex.add(pb.Model(i: '5', t: DateTime(2023, 1, 5).timestamp));

      final view = modelIndex.filter().toList();
      expect(view.length, 5);
      expect(view[0].i, '5');
      expect(view[1].i, '4');
      expect(view[2].i, '3');
      expect(view[3].i, '2');
      expect(view[4].i, '1');

      final viewAsc = modelIndex.filter(sortDesc: false).toList();
      expect(viewAsc.length, 5);
      expect(viewAsc[0].i, '1');
      expect(viewAsc[1].i, '2');
      expect(viewAsc[2].i, '3');
      expect(viewAsc[3].i, '4');
      expect(viewAsc[4].i, '5');
    });

    test('filter should filter by date', () async {
      final modelIndex = ModelIndex();
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      await modelIndex.add(pb.Model(i: '4', t: DateTime(2023, 1, 4).timestamp));
      await modelIndex.add(pb.Model(i: '5', t: DateTime(2023, 1, 5).timestamp));

      final viewFrom = modelIndex.filter(from: DateTime(2023, 1, 2)).toList();
      expect(viewFrom.length, 4);
      expect(viewFrom[0].i, '5');
      expect(viewFrom[1].i, '4');
      expect(viewFrom[2].i, '3');
      expect(viewFrom[3].i, '2');

      final viewTo = modelIndex.filter(to: DateTime(2023, 1, 4)).toList();
      expect(viewTo.length, 4);
      expect(viewTo[0].i, '4');
      expect(viewTo[1].i, '3');
      expect(viewTo[2].i, '2');
      expect(viewTo[3].i, '1');

      final viewFromTo = modelIndex.filter(from: DateTime(2023, 1, 2), to: DateTime(2023, 1, 4)).toList();
      expect(viewFromTo.length, 3);
      expect(viewFromTo[0].i, '4');
      expect(viewFromTo[1].i, '3');
      expect(viewFromTo[2].i, '2');
    });

    test('cutoff should remove object before expired date', () async {
      String? removedId;
      final modelIndex = ModelIndex(onRemove: (id) async => removedId = id);
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      await modelIndex.add(pb.Model(i: '4', t: DateTime(2023, 1, 4).timestamp));
      await modelIndex.add(pb.Model(i: '5', t: DateTime(2023, 1, 5).timestamp));

      await modelIndex.cutOff(DateTime(2023, 1, 3));
      expect(modelIndex.length, 3);
      expect(modelIndex[0].i, '3');
      expect(modelIndex[1].i, '4');
      expect(modelIndex[2].i, '5');
      expect(removedId, '2');
    });

    test('add should remove object ', () async {
      String? removedId;
      final modelIndex = ModelIndex(onRemove: (id) async => removedId = id);
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));

      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 4).timestamp));
      expect(modelIndex.length, 3);
      expect(removedId, '1');
      expect(modelIndex.where('1')!.t.toDateTime().day, 4);
    });

    test('writeToJsonMap should convert to json map ', () async {
      final modelIndex = ModelIndex();
      modelIndex.noOldData = true;
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      final jsonMap = modelIndex.writeToJsonMap();

      final modelIndex2 = ModelIndex()..fromJsonMap(jsonMap);
      expect(modelIndex2.length, 3);
      expect(modelIndex2[0].t.toDateTime().year, 2023);
      expect(modelIndex2[0].t.toDateTime().day, 3);
      expect(modelIndex2[0].i, "3");
      expect(modelIndex2.noOldData, true);
    });

    test('isOldDataAvailable should return false when no old data', () async {
      final modelIndex = ModelIndex();
      modelIndex.noOldData = true;
      expect(modelIndex.isOldDataAvailable(DateTime.now()), false);
    });

    test('isOldDataAvailable should return false when data already in local', () async {
      final modelIndex = ModelIndex();
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      expect(modelIndex.isOldDataAvailable(DateTime(2023, 1, 2)), false);
    });

    test('isOldDataAvailable should return true when data has same day in local', () async {
      final modelIndex = ModelIndex();
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      expect(modelIndex.isOldDataAvailable(DateTime(2023, 1, 1)), true);
    });

    test('isOldDataAvailable should return true when data not as old as user want', () async {
      final modelIndex = ModelIndex();
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      expect(modelIndex.isOldDataAvailable(DateTime(2022, 1, 1)), true);
    });

    test('totalPages should calculate total pages', () async {
      final modelIndex = ModelIndex(rowsPerPage: 2);
      await modelIndex.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      await modelIndex.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      await modelIndex.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      expect(modelIndex.totalPages, 2);
    });
  });
}
