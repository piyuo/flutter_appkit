// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'data_pod.dart';

void main() {
  setUpAll(() async {
    await db.initForTest();
    await cache.initForTest();
  });

  setUp(() async {
    await cache.reset();
  });

  group('[data_pod]', () {
    test('should get/set/delete', () async {
      bool isSet = false;
      bool isGet = false;
      bool isDelete = false;
      final dp = DataPod<sample.Person>(
        id: 'testId',
        dataBuilder: () => sample.Person(),
        dataGetter: (context, id) async {
          isGet = true;
          return sample.Person(entity: pb.Entity(id: 'testId'));
        },
        dataSetter: (context, sample.Person person) async {
          isSet = true;
        },
        dataRemover: (context, ids) async {
          isDelete = true;
        },
      );

      final person = await dp.get(testing.Context());
      expect(isGet, isTrue);
      expect(person, isNotNull);

      await dp.set(testing.Context(), person!);
      expect(isSet, isTrue);

      await dp.delete(testing.Context());
      expect(isDelete, isTrue);
    });
  });
}
