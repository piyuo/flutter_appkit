// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'model_index.dart';

void main() {
  group('[cache.model_index]', () {
    test('should remove old before add', () {
      final modelList = ModelIndex();
      final modelOld = pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp);
      modelList.add(modelOld);

      expect(modelList[0].t.toDateTime().year, 2023);
      expect(modelList[0].t.toDateTime().day, 1);
      expect(modelList.length, 1);
      final modelNew = pb.Model(i: '1', t: DateTime(2023, 1, 2).timestamp);
      final added = modelList.add(modelNew);
      expect(added, true);
      expect(modelList.length, 1);
      expect(modelList[0].t.toDateTime().year, 2023);
      expect(modelList[0].t.toDateTime().day, 2);
    });

    test('should not add if not newest', () {
      final modelList = ModelIndex();
      final model = pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp);
      modelList.add(model);
      expect(modelList[0].t.toDateTime().day, 1);
      expect(modelList.length, 1);
      final modelOld = pb.Model(i: '1', t: DateTime(2022, 1, 2).timestamp);
      final added = modelList.add(modelOld);
      expect(added, false);
      expect(modelList.length, 1);
      expect(modelList[0].t.toDateTime().year, 2023);
      expect(modelList[0].t.toDateTime().day, 1);
    });

    test('should remove old before addAll', () {
      final modelList = ModelIndex();
      modelList.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      modelList.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      expect(modelList[0].t.toDateTime().day, 1);
      expect(modelList[1].t.toDateTime().day, 2);

      modelList.add(pb.Model(i: '1', t: DateTime(2023, 1, 3).timestamp));
      modelList.add(pb.Model(i: '2', t: DateTime(2023, 1, 4).timestamp));
      expect(modelList.length, 2);
      expect(modelList[0].t.toDateTime().day, 3);
      expect(modelList[1].t.toDateTime().day, 4);
    });

    test('should sort by time', () {
      final modelList = ModelIndex();
      modelList.add(pb.Model(i: '1', t: DateTime(2023, 2, 1).timestamp));
      modelList.add(pb.Model(i: '2', t: DateTime(2023, 1, 1).timestamp));
      modelList.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      expect(modelList.length, 3);
      modelList.sort();
      expect(modelList[0].i, '2');
      expect(modelList[1].i, '3');
      expect(modelList[2].i, '1');
    });

    test('should sort by time desc', () {
      final modelList = ModelIndex();
      modelList.add(pb.Model(i: '1', t: DateTime(2023, 2, 1).timestamp));
      modelList.add(pb.Model(i: '2', t: DateTime(2023, 1, 1).timestamp));
      modelList.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      expect(modelList.length, 3);
      modelList.sort(desc: true);
      expect(modelList[0].i, '1');
      expect(modelList[1].i, '3');
      expect(modelList[2].i, '2');
    });

    test('should return true if already contains a model', () {
      final modelList = ModelIndex();
      modelList.add(pb.Model(i: '1', t: DateTime(2023, 2, 1).timestamp));
      expect(modelList.contains(pb.Model(i: '1', t: DateTime(2023, 2, 1).timestamp)), true);
      expect(modelList.contains(pb.Model(i: '2', t: DateTime(2023, 2, 1).timestamp)), false);
    });

    test('should return newest/oldest model', () {
      final modelList = ModelIndex();

      modelList.add(pb.Model(i: '1', t: DateTime(2023, 1, 2).timestamp));
      modelList.add(pb.Model(i: '2', t: DateTime(2023, 1, 1).timestamp));
      modelList.add(pb.Model(i: '3', t: DateTime(2023, 1, 4).timestamp));

      expect(modelList.newest.i, '3');
      expect(modelList.oldest.i, '2');
    });

    test('should create view and sort', () {
      final modelList = ModelIndex();
      modelList.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      modelList.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      modelList.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      modelList.add(pb.Model(i: '4', t: DateTime(2023, 1, 4).timestamp));
      modelList.add(pb.Model(i: '5', t: DateTime(2023, 1, 5).timestamp));

      final view = modelList.createView().toList();
      expect(view.length, 5);
      expect(view[0].i, '5');
      expect(view[1].i, '4');
      expect(view[2].i, '3');
      expect(view[3].i, '2');
      expect(view[4].i, '1');

      final viewAsc = modelList.createView(sortDesc: false).toList();
      expect(viewAsc.length, 5);
      expect(viewAsc[0].i, '1');
      expect(viewAsc[1].i, '2');
      expect(viewAsc[2].i, '3');
      expect(viewAsc[3].i, '4');
      expect(viewAsc[4].i, '5');
    });

    test('should create view and filter by date', () {
      final modelList = ModelIndex();
      modelList.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      modelList.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      modelList.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      modelList.add(pb.Model(i: '4', t: DateTime(2023, 1, 4).timestamp));
      modelList.add(pb.Model(i: '5', t: DateTime(2023, 1, 5).timestamp));

      final viewFrom = modelList.createView(from: DateTime(2023, 1, 2)).toList();
      expect(viewFrom.length, 4);
      expect(viewFrom[0].i, '5');
      expect(viewFrom[1].i, '4');
      expect(viewFrom[2].i, '3');
      expect(viewFrom[3].i, '2');

      final viewTo = modelList.createView(to: DateTime(2023, 1, 4)).toList();
      expect(viewTo.length, 4);
      expect(viewTo[0].i, '4');
      expect(viewTo[1].i, '3');
      expect(viewTo[2].i, '2');
      expect(viewTo[3].i, '1');

      final viewFromTo = modelList.createView(from: DateTime(2023, 1, 2), to: DateTime(2023, 1, 4)).toList();
      expect(viewFromTo.length, 3);
      expect(viewFromTo[0].i, '4');
      expect(viewFromTo[1].i, '3');
      expect(viewFromTo[2].i, '2');
    });

    test('should remove object before cutOffDate', () {
      String? removedId;
      final modelList = ModelIndex(onRemove: (id) => removedId = id);
      modelList.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      modelList.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      modelList.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      modelList.add(pb.Model(i: '4', t: DateTime(2023, 1, 4).timestamp));
      modelList.add(pb.Model(i: '5', t: DateTime(2023, 1, 5).timestamp));

      modelList.cutOffDate = DateTime(2023, 1, 3);
      expect(modelList.length, 3);
      expect(modelList[0].i, '3');
      expect(modelList[1].i, '4');
      expect(modelList[2].i, '5');
      expect(removedId, '2');
    });

    test('should remove object ', () {
      String? removedId;
      final modelList = ModelIndex(onRemove: (id) => removedId = id);
      modelList.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      modelList.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      modelList.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));

      modelList.remove('1');
      expect(modelList.length, 2);
      expect(removedId, '1');
    });

    test('should convert to json map ', () {
      final modelList = ModelIndex();
      modelList.add(pb.Model(i: '3', t: DateTime(2023, 1, 3).timestamp));
      modelList.add(pb.Model(i: '1', t: DateTime(2023, 1, 1).timestamp));
      modelList.add(pb.Model(i: '2', t: DateTime(2023, 1, 2).timestamp));
      modelList.cutOffDate = DateTime(2023, 1, 2);
      modelList.lastRefreshDate = DateTime(2023, 1, 3);

      final jsonMap = modelList.writeToJsonMap();

      final modelList2 = ModelIndex()..fromJsonMap(jsonMap);
      expect(modelList2.length, 2);
      expect(modelList2[0].t.toDateTime().year, 2023);
      expect(modelList2[0].t.toDateTime().day, 3);
      expect(modelList2[0].i, "3");
      expect(modelList2.cutOffDate!.day, 2);
      expect(modelList2.lastRefreshDate!.day, 3);
    });

    test('should allow cutOffDate null in json map ', () {
      final modelList = ModelIndex();
      modelList.cutOffDate = null;
      modelList.lastRefreshDate = null;
      final jsonMap = modelList.writeToJsonMap();
      final modelList2 = ModelIndex()..fromJsonMap(jsonMap);
      expect(modelList2.cutOffDate, isNull);
      expect(modelList2.lastRefreshDate, isNull);
    });

    test('should allow cutOffDate null in json map ', () {
      final modelList = ModelIndex();
      modelList.cutOffDate = null;
      modelList.lastRefreshDate = null;
      final jsonMap = modelList.writeToJsonMap();
      final modelList2 = ModelIndex()..fromJsonMap(jsonMap);
      expect(modelList2.cutOffDate, isNull);
      expect(modelList2.lastRefreshDate, isNull);
    });
  });
}
