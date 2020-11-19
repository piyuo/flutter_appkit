import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/preference.dart' as preferences;

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  preferences.mockPrefs({});
  setUp(() async {});

  group('[preference]', () {
    test('should remove', () async {
      await preferences.setBool('k', true);
      var result = await preferences.getBool('k');
      expect(result, true);

      await preferences.remove('k');
      result = await preferences.getBool('k');
      expect(result, false);
    });

    test('should get/set bool', () async {
      await preferences.setBool('k', true);
      var result = await preferences.getBool('k');
      expect(result, true);

      await preferences.setBool('k', false);
      result = await preferences.getBool('k');
      expect(result, false);
    });

    test('should get false when no data', () async {
      var result = await preferences.getBool('na');
      expect(result, false);
    });

    test('should get/set Int', () async {
      await preferences.setInt('k', 1);
      var result = await preferences.getInt('k');
      expect(result, 1);
    });

    test('should get 0 when no data', () async {
      var result = await preferences.getInt('na');
      expect(result, 0);
    });

    test('should get/set double', () async {
      await preferences.setDouble('k', 1.1);
      var result = await preferences.getDouble('k');
      expect(result, 1.1);
    });

    test('should get 0 when no data', () async {
      var result = await preferences.getDouble('na');
      expect(result, 0);
    });

    test('should get/set string', () async {
      await preferences.setString('k', 'a');
      var result = await preferences.getString('k');
      expect(result, 'a');
    });

    test('should get/set datetime', () async {
      var now = DateTime.now();
      var short = now.toString().toString().substring(0, 16);
      await preferences.setDateTime('k', now);
      var result = await preferences.getDateTime('k');
      expect(result.toString().substring(0, 16), short);
    });

    test('should get empty string when no data', () async {
      var result = await preferences.getString('na');
      expect(result, '');
    });

    test('should get/set string list', () async {
      var list = ['a', 'b', 'c'];
      await preferences.setStringList('k', list);
      var result = await preferences.getStringList('k');
      expect(result[1], 'b');
    });

    test('should get empty list when no data', () async {
      var result = await preferences.getStringList('na');
      expect(result, []);
    });

    test('should get/set map', () async {
      Map<String, dynamic> map = Map<String, dynamic>();
      map['a'] = 1;
      map['b'] = 2;

      await preferences.setMap('k', map);
      var result = await preferences.getMap('k');
      expect(result['b'], 2);
    });
  });
}
