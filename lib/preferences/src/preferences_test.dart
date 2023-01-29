import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'preferences.dart';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  initForTest({});
  setUp(() async {});

  group('[preferences]', () {
    test('should clear', () async {
      await setBool('k', true);
      var found = await containsKey('k');
      expect(found, true);
      await clear();
      found = await containsKey('k');
      expect(found, false);
    });

    test('should check contains key', () async {
      var found = await containsKey('k');
      expect(found, false);
      await setBool('k', true);
      found = await containsKey('k');
      expect(found, true);
      await remove('k');
      found = await containsKey('k');
      expect(found, false);
    });

    test('should remove', () async {
      await setBool('k', true);
      var result = await getBool('k');
      expect(result, true);

      await remove('k');
      result = await getBool('k');
      expect(result, null);
    });

    test('should get/set bool', () async {
      await setBool('k', true);
      var result = await getBool('k');
      expect(result, true);

      await setBool('k', false);
      result = await getBool('k');
      expect(result, false);
      await remove('k');
      result = await getBool('k');
      expect(result, null);

      await setBool('k', false);
      await setBool('k', null);
      result = await getBool('k');
      expect(result, null);
    });

    test('should get/set Int', () async {
      await setInt('k', 1);
      var result = await getInt('k');
      expect(result, 1);
      await remove('k');
      result = await getInt('k');
      expect(result, null);

      await setInt('k', 1);
      await setInt('k', null);
      result = await getInt('k');
      expect(result, null);
    });

    test('should get/set double', () async {
      await setDouble('k', 1.1);
      var result = await getDouble('k');
      expect(result, 1.1);
      await remove('k');
      result = await getDouble('k');
      expect(result, null);

      await setDouble('k', 1.1);
      await setDouble('k', null);
      result = await getDouble('k');
      expect(result, null);
    });

    test('should get/set string', () async {
      await setString('k', 'a');
      var result = await getString('k');
      expect(result, 'a');
      await remove('k');
      result = await getString('k');
      expect(result, null);

      await setString('k', 'a');
      await setString('k', null);
      result = await getString('k');
      expect(result, null);
    });

    test('should get/set string with expiration time', () async {
      var now = DateTime.now();
      var exp = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
      exp = exp.add(const Duration(seconds: 1));
      await setStringWithExp('k', 'a', exp);

      // check exp key
      var expInPref = await getDateTime('k$expirationExt');
      expect(exp, expInPref);
      final str = await getStringWithExp('k');
      expect(str, 'a');
      expect(await containsKey('k'), true);
      expect(await containsKey('k$expirationExt'), true);

      // let key expired
      await Future.delayed(const Duration(seconds: 1));
      final str2 = await getStringWithExp('k');
      expect(str2, null);

      expect(await containsKey('k'), false);
      expect(await containsKey('k$expirationExt'), false);
    });

    test('should get/set datetime', () async {
      var now = DateTime.now();
      var shortStr = now.toString().toString().substring(0, 19);
      final value = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
      await setDateTime('k', value);
      var result = await getDateTime('k');
      expect(result.toString().substring(0, 19), shortStr);
      expect(result, value);
      await remove('k');
      result = await getDateTime('k');
      expect(result, null);

      await setDateTime('k', value);
      await setDateTime('k', null);
      result = await getDateTime('k');
      expect(result, null);
    });

    test('should get/set string list', () async {
      var list = ['a', 'b', 'c'];
      await setStringList('k', list);
      var result = await getStringList('k');
      expect(result![1], 'b');
      await remove('k');
      result = await getStringList('k');
      expect(result, null);
    });

    test('should get/set map', () async {
      Map<String, dynamic> map = <String, dynamic>{};
      map['a'] = 1;
      map['b'] = 2;

      await setMap('k', map);
      var result = await getMap('k');
      expect(result!['b'], 2);
      await remove('k');
      result = await getMap('k');
      expect(result, null);
    });

    test('should get/set map list', () async {
      Map<String, dynamic> map1 = <String, dynamic>{};
      map1['a'] = 1;
      map1['b'] = 2;

      Map<String, dynamic> map2 = <String, dynamic>{};
      map2['a'] = 'a';
      map2['b'] = 'b';

      var list = <Map<String, dynamic>>[];
      list.add(map1);
      list.add(map2);

      await setMapList('k', list);
      var result = await getMapList('k');
      expect(result![0]['a'], 1);
      expect(result[1]['a'], 'a');
      expect(result[0]['b'], 2);
      expect(result[1]['b'], 'b');
      await remove('k');
      result = await getMapList('k');
      expect(result, null);
    });

    test('should set/get object', () async {
      final person = sample.Person(name: '123');
      await setObject('p', person);
      var p = await getObject<sample.Person>('p', () => sample.Person());
      expect(p, isNotNull);
      expect(p!.name, person.name);
      await remove('p');
      var p2 = await getObject<sample.Person>('p', () => sample.Person());
      expect(p2, isNull);
    });
  });
}
