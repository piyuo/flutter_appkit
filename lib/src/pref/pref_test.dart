import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/pref/pref.dart';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  mock({});
  setUp(() async {});

  group('[pref]', () {
    test('should remove', () async {
      await setBool('k', true);
      var result = await getBool('k');
      expect(result, true);

      await remove('k');
      result = await getBool('k');
      expect(result, false);
    });

    test('should get/set bool', () async {
      await setBool('k', true);
      var result = await getBool('k');
      expect(result, true);

      await setBool('k', false);
      result = await getBool('k');
      expect(result, false);
    });

    test('should get false when no data', () async {
      var result = await getBool('na');
      expect(result, false);
    });

    test('should get/set Int', () async {
      await setInt('k', 1);
      var result = await getInt('k');
      expect(result, 1);
    });

    test('should get 0 when no data', () async {
      var result = await getInt('na');
      expect(result, 0);
    });

    test('should get/set double', () async {
      await setDouble('k', 1.1);
      var result = await getDouble('k');
      expect(result, 1.1);
    });

    test('should get 0 when no data', () async {
      var result = await getDouble('na');
      expect(result, 0);
    });

    test('should get/set string', () async {
      await setString('k', 'a');
      var result = await getString('k');
      expect(result, 'a');
    });

    test('should get/set string with expiration time', () async {
      var now = DateTime.now();
      var exp = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
      exp = exp.add(Duration(seconds: 1));
      await setStringWithExp('k', 'a', exp);

      // check exp key
      var expInPref = await getDateTime('k' + expirationExt);
      expect(exp, expInPref);
      final str = await getStringWithExp('k');
      expect(str, 'a');

      // let key expired
      await Future.delayed(Duration(seconds: 1));
      final str2 = await getStringWithExp('k');
      expect(str2, '');
    });

    test('should get/set datetime', () async {
      var now = DateTime.now();
      var shortStr = now.toString().toString().substring(0, 19);
      final value = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
      await setDateTime('k', value);
      var result = await getDateTime('k');
      expect(result.toString().substring(0, 19), shortStr);
      expect(result, value);
    });

    test('should get empty string when no data', () async {
      var result = await getString('na');
      expect(result, '');
    });

    test('should get/set string list', () async {
      var list = ['a', 'b', 'c'];
      await setStringList('k', list);
      var result = await getStringList('k');
      expect(result[1], 'b');
    });

    test('should get empty list when no data', () async {
      var result = await getStringList('na');
      expect(result, []);
    });

    test('should get/set map', () async {
      Map<String, dynamic> map = Map<String, dynamic>();
      map['a'] = 1;
      map['b'] = 2;

      await setMap('k', map);
      var result = await getMap('k');
      expect(result['b'], 2);
    });
  });
}
