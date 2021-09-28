// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb.dart' as pb;
import 'package:libcli/storage.dart' as storage;
import 'disk_cache.dart';
import 'registries.dart';

void main() {
  setUp(() {
    storage.clear();
    mockRegistries = null;
  });

  group('[disk_cache]', () {
    test('should add/get obj', () async {
      final obj = pb.Error()..code = 'hi';
      var result = await add('key1', obj);
      expect(result, true);

      final obj2 = await get<pb.Error>('key1', pb.Error());
      expect(obj2, isNotNull);
      expect(obj.code, obj2!.code);

      final notExists = await get<pb.Error>('notExists', pb.Error());
      expect(notExists, isNull);
    });

    test('should add/get list', () async {
      final obj1 = pb.Error()..code = '1';
      final obj2 = pb.Error()..code = '2';
      final list = [obj1, obj2];

      var result = await addList('key1', list);
      expect(result, true);

      final list2 = await getList<pb.Error>('key1', () => pb.Error());
      expect(list2, isNotNull);
      expect(list2![0].code, list[0].code);
      expect(list2[1].code, list[1].code);

      final notExists = await getList<pb.Error>('notExists', () => pb.Error());
      expect(notExists, isNull);
    });
  });
}
