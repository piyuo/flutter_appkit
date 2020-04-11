import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/prefs.dart' as prefs;

void main() {
  prefs.mock({});
  setUp(() async {});

  group('[prefs]', () {
    test('should get/set bool', () async {
      await prefs.setBool('k', true);
      var result = await prefs.getBool('k');
      expect(result, true);

      await prefs.setBool('k', false);
      result = await prefs.getBool('k');
      expect(result, false);
    });

    test('should get false when no data', () async {
      var result = await prefs.getBool('na');
      expect(result, false);
    });

    test('should get/set Int', () async {
      await prefs.setInt('k', 1);
      var result = await prefs.getInt('k');
      expect(result, 1);
    });

    test('should get 0 when no data', () async {
      var result = await prefs.getInt('na');
      expect(result, 0);
    });

    test('should get/set double', () async {
      await prefs.setDouble('k', 1.1);
      var result = await prefs.getDouble('k');
      expect(result, 1.1);
    });

    test('should get 0 when no data', () async {
      var result = await prefs.getDouble('na');
      expect(result, 0);
    });

    test('should get/set string', () async {
      await prefs.setString('k', 'a');
      var result = await prefs.getString('k');
      expect(result, 'a');
    });

    test('should get/set datetime', () async {
      var now = DateTime.now();
      var short = now.toString().toString().substring(0, 16);
      await prefs.setDateTime('k', now);
      var result = await prefs.getDateTime('k');
      expect(result.toString().substring(0, 16), short);
    });

    test('should get empty string when no data', () async {
      var result = await prefs.getString('na');
      expect(result, '');
    });

    test('should get/set string list', () async {
      var list = ['a', 'b', 'c'];
      await prefs.setStringList('k', list);
      var result = await prefs.getStringList('k');
      expect(result[1], 'b');
    });

    test('should get empty list when no data', () async {
      var result = await prefs.getStringList('na');
      expect(result, []);
    });

    test('should get/set map', () async {
      Map<String, dynamic> map = Map<String, dynamic>();
      map['a'] = 1;
      map['b'] = 2;

      await prefs.setMap('k', map);
      var result = await prefs.getMap('k');
      expect(result['b'], 2);
    });
  });
}
