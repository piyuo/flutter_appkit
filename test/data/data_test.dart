import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libcli/data/data.dart' as data;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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

    test('should get/set Int', () async {
      await data.setInt('k', 1);
      var result = await data.getInt('k');
      expect(result, 1);
    });

    test('should get/set doublel', () async {
      await data.setDouble('k', 1.1);
      var result = await data.getDouble('k');
      expect(result, 1.1);
    });

    test('should get/set string', () async {
      await data.setString('k', 'a');
      var result = await data.getString('k');
      expect(result, 'a');
    });

    test('should get/set string list', () async {
      var list = ['a', 'b', 'c'];
      await data.setStringList('k', list);
      var result = await data.getStringList('k');
      expect(result[1], 'b');
    });
  });
}
