import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/data/data.dart' as data;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  setUp(() async {});

  group('[data]', () {
    test('should get/set bool', () async {
      await data.setBool('k', true);
      var result = await data.getBool('k');
      expect(result, true);

      await data.setBool('k', false);
      result = await data.getBool('k');
      expect(result, false);
    });

    test('should get false when no data', () async {
      var result = await data.getBool('na');
      expect(result, false);
    });

    test('should get/set Int', () async {
      await data.setInt('k', 1);
      var result = await data.getInt('k');
      expect(result, 1);
    });

    test('should get 0 when no data', () async {
      var result = await data.getInt('na');
      expect(result, 0);
    });

    test('should get/set double', () async {
      await data.setDouble('k', 1.1);
      var result = await data.getDouble('k');
      expect(result, 1.1);
    });

    test('should get 0 when no data', () async {
      var result = await data.getDouble('na');
      expect(result, 0);
    });

    test('should get/set string', () async {
      await data.setString('k', 'a');
      var result = await data.getString('k');
      expect(result, 'a');
    });

    test('should get empty string when no data', () async {
      var result = await data.getString('na');
      expect(result, '');
    });

    test('should get/set string list', () async {
      var list = ['a', 'b', 'c'];
      await data.setStringList('k', list);
      var result = await data.getStringList('k');
      expect(result[1], 'b');
    });

    test('should get empty list when no data', () async {
      var result = await data.getStringList('na');
      expect(result, []);
    });

    test('should get/set map', () async {
      Map<String, dynamic> map = Map<String, dynamic>();
      map['a'] = 1;
      map['b'] = 2;

      await data.setMap('k', map);
      var result = await data.getMap('k');
      expect(result['b'], 2);
    });
  });
}
