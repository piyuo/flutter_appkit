import 'package:flutter_test/flutter_test.dart';
import 'main.dart';

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

    test('should get/set datetime', () async {
      var now = DateTime.now();
      var short = now.toString().toString().substring(0, 16);
      await setDateTime('k', now);
      var result = await getDateTime('k');
      expect(result.toString().substring(0, 16), short);
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
