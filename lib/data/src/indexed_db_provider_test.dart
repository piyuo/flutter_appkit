// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:libcli/sample/sample.dart' as sample;
import 'package:flutter_test/flutter_test.dart';
import 'indexed_db_provider.dart';

void main() {
  group('[cache.indexed_db_provider]', () {
    test('should delete', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_delete');
      await indexedDbProvider.init();
      await indexedDbProvider.put('k', true);
      expect(indexedDbProvider.containsKey('k'), true);
      await indexedDbProvider.delete('k');
      expect(indexedDbProvider.containsKey('k'), false);
      await indexedDbProvider.removeBox();
    });

    test('should put/get', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_put');
      await indexedDbProvider.init();
      await indexedDbProvider.put('k', false);
      final value = await indexedDbProvider.get('k');
      expect(value, false);
      await indexedDbProvider.removeBox();
    });

    test('should set/get map', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_map');
      await indexedDbProvider.init();
      await indexedDbProvider.put('k', {
        'a': 1,
        'b': ['x', 'y']
      });
      final value = await indexedDbProvider.get('k');
      expect(value!['a'], 1);
      expect(value['b'][0], 'x');
      expect(value['b'][1], 'y');
      await indexedDbProvider.removeBox();
    });

    test('should get json map', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_json_map');
      await indexedDbProvider.init();
      await indexedDbProvider.put('k', {
        'a': 1,
        'b': ['x', 'y']
      });
      final value = await indexedDbProvider.getJsonMap('k');
      expect(value is Map<String, dynamic>, true);
      await indexedDbProvider.removeBox();
    });

    test('should set/get int', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_int');
      await indexedDbProvider.init();
      await indexedDbProvider.put('k', 1);
      final value = await indexedDbProvider.get('k');
      expect(value, 1);
      await indexedDbProvider.removeBox();
    });

    test('should set/get string', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_string');
      await indexedDbProvider.init();
      await indexedDbProvider.put('k', 'hi');
      final value = await indexedDbProvider.get('k');
      expect(value, 'hi');
      await indexedDbProvider.removeBox();
    });

    test('should set/get datetime', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_datetime');
      await indexedDbProvider.init();
      final now = DateTime.now();
      await indexedDbProvider.put('k', now);
      final value = await indexedDbProvider.get('k');
      expect(now.year, value!.year);
      expect(now.month, value.month);
      expect(now.day, value.day);
      expect(now.hour, value.hour);
      expect(now.minute, value.minute);
      await indexedDbProvider.removeBox();
    });

    test('should set/get pb.object', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_object');
      await indexedDbProvider.init();
      final person = sample.Person(name: 'l');
      await indexedDbProvider.putObject('k', person);
      final value = await indexedDbProvider.getObject<sample.Person>('k', () => sample.Person());
      expect(value, isNotNull);
      expect(value!.name, 'l');
      expect(value, person);
      await indexedDbProvider.removeBox();
    });

    test('should save string list', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_string_list');
      await indexedDbProvider.init();
      final list = <String>['1', '2', '3'];
      await indexedDbProvider.put('l', list);
      var list2 = await indexedDbProvider.get('l');
      expect(list2!.length, 3);
      expect(list2[2], '3');
      await indexedDbProvider.removeBox();
    });

    test('should save int list', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_string_list');
      await indexedDbProvider.init();
      final list = <int>[1, 2, 3];
      await indexedDbProvider.put('l', list);
      var list2 = await indexedDbProvider.get('l');
      expect(list2!.length, 3);
      expect(list2[2], 3);
      await indexedDbProvider.removeBox();
    });

    test('should clear', () async {
      final indexedDbProvider = IndexedDbProvider(dbName: 'test_string_list');
      await indexedDbProvider.init();
      await indexedDbProvider.put('a', 'b');
      await indexedDbProvider.put('1', '2');
      await indexedDbProvider.clear();
      expect(indexedDbProvider.containsKey('a'), false);
      expect(indexedDbProvider.containsKey('1'), false);
      await indexedDbProvider.removeBox();
    });
  });
}
