import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'assets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    // ignore: invalid_use_of_visible_for_testing_member
    mockDone();
  });

  group('[asset]', () {
    test('should load string', () async {
      String text = await loadString(assetName: 'test/test.json');
      expect(text, isNotEmpty);
      expect(text.indexOf('A'), greaterThan(0));
    });

    test('should load json', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      mock('');
      String j = await loadJson(assetName: 'mock');
      var obj = json.decode(j);
      expect(obj is Map, true);
    });

    test('should load map', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      mock('{}');
      Map map = await loadMap(assetName: '');
      expect(map, isEmpty);
    });

    test('should load string in package', () async {
      String text = await loadString(assetName: 'i18n/mock.json', package: 'libcli');
      expect(text, isNotEmpty);
    });

    test('should return empty if asset not exist', () async {
      String text = await loadString(assetName: 'not exist.json');
      expect(text, isEmpty);
    });

    test('should use mock text', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      mock('hi');
      String text = await loadString(assetName: 'test/test.json');
      expect(text, 'hi');
    });
  });
}
