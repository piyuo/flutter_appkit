// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:libcli/sample/sample.dart' as sample;
import 'package:flutter_test/flutter_test.dart';
import 'indexed_db.dart';

void main() {
  group('[cache.indexed_db]', () {
    test('should delete', () async {
      final indexedDb = IndexedDb(dbName: 'test_delete');
      await indexedDb.init();
      await indexedDb.put('k', true);
      expect(indexedDb.containsKey('k'), true);
      await indexedDb.delete('k');
      expect(indexedDb.containsKey('k'), false);
      await indexedDb.removeBox();
    });

    test('should put/get', () async {
      final indexedDb = IndexedDb(dbName: 'test_put');
      await indexedDb.init();
      await indexedDb.put('k', false);
      final value = await indexedDb.get('k');
      expect(value, false);
      await indexedDb.removeBox();
    });

    test('should set/get map', () async {
      final indexedDb = IndexedDb(dbName: 'test_map');
      await indexedDb.init();
      await indexedDb.put('k', {
        'a': 1,
        'b': ['x', 'y'],
      });
      final value = await indexedDb.get('k');
      expect(value!['a'], 1);
      expect(value['b'][0], 'x');
      expect(value['b'][1], 'y');
      await indexedDb.removeBox();
    });

    test('should get json map', () async {
      final indexedDb = IndexedDb(dbName: 'test_json_map');
      await indexedDb.init();
      await indexedDb.put('k', {
        'a': 1,
        'b': ['x', 'y'],
        'c': [
          {'g': 'h'},
          {'i': 'j'}
        ]
      });
      final value = await indexedDb.getJsonMap('k');
      expect(value is Map<String, dynamic>, true);
      expect(value!['c'][0] is Map<String, dynamic>, true);
      expect(value['c'][1] is Map<String, dynamic>, true);
      await indexedDb.removeBox();
    });

    test('should set/get int', () async {
      final indexedDb = IndexedDb(dbName: 'test_int');
      await indexedDb.init();
      await indexedDb.put('k', 1);
      final value = await indexedDb.get('k');
      expect(value, 1);
      await indexedDb.removeBox();
    });

    test('should set/get string', () async {
      final indexedDb = IndexedDb(dbName: 'test_string');
      await indexedDb.init();
      await indexedDb.put('k', 'hi');
      final value = await indexedDb.get('k');
      expect(value, 'hi');
      await indexedDb.removeBox();
    });

    test('should set/get datetime', () async {
      final indexedDb = IndexedDb(dbName: 'test_datetime');
      await indexedDb.init();
      final now = DateTime.now();
      await indexedDb.put('k', now);
      final value = await indexedDb.get('k');
      expect(now.year, value!.year);
      expect(now.month, value.month);
      expect(now.day, value.day);
      expect(now.hour, value.hour);
      expect(now.minute, value.minute);
      await indexedDb.removeBox();
    });

    test('should set/get pb.object', () async {
      final indexedDb = IndexedDb(dbName: 'test_object');
      await indexedDb.init();
      final person = sample.Person(name: 'l');
      await indexedDb.putObject('k', person);
      final value = await indexedDb.getObject<sample.Person>('k', () => sample.Person());
      expect(value, isNotNull);
      expect(value!.name, 'l');
      expect(value, person);
      await indexedDb.removeBox();
    });

    test('should save string list', () async {
      final indexedDb = IndexedDb(dbName: 'test_string_list');
      await indexedDb.init();
      final list = <String>['1', '2', '3'];
      await indexedDb.put('l', list);
      var list2 = await indexedDb.get('l');
      expect(list2!.length, 3);
      expect(list2[2], '3');
      await indexedDb.removeBox();
    });

    test('should save int list', () async {
      final indexedDb = IndexedDb(dbName: 'test_string_list');
      await indexedDb.init();
      final list = <int>[1, 2, 3];
      await indexedDb.put('l', list);
      var list2 = await indexedDb.get('l');
      expect(list2!.length, 3);
      expect(list2[2], 3);
      await indexedDb.removeBox();
    });

    test('should clear', () async {
      final indexedDb = IndexedDb(dbName: 'test_string_list');
      await indexedDb.init();
      await indexedDb.put('a', 'b');
      await indexedDb.put('1', '2');
      await indexedDb.clear();
      expect(indexedDb.containsKey('a'), false);
      expect(indexedDb.containsKey('1'), false);
      await indexedDb.removeBox();
    });

    test('keys should iterable', () async {
      final indexedDb = IndexedDb(dbName: 'test_indexed_db_keys');
      await indexedDb.init();
      await indexedDb.put('a', 'b');
      await indexedDb.put('1', '2');
      final keys = indexedDb.keys;
      for (final key in keys) {
        expect(key == 'a' || key == '1', true);
      }
      await indexedDb.removeBox();
    });
  });
}
