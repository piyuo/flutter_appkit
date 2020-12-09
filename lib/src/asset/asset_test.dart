import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/src/asset/asset.dart';
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    // ignore: invalid_use_of_visible_for_testing_member
    mockAssetsStop();
  });

  group('[asset]', () {
    test('should load string', () async {
      String text = await loadString(assetName: 'test/test.json');
      expect(text, isNotEmpty);
      expect(text.indexOf('A'), greaterThan(0));
    });

    test('should load json', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      mockAssetsByString('');
      String j = await loadJson(assetName: 'mock');
      var obj = json.decode(j);
      expect(obj is Map, true);
    });

    test('should load map', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      mockAssetsByString('{}');
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

    test('should mock', () async {
      Future<String> _mockLoadAssets({required String assetName, BuildContext? context, String? package}) async {
        return 'hi';
      }

      // ignore: invalid_use_of_visible_for_testing_member
      mockAssets((_mockLoadAssets));

      String text = await loadString(assetName: 'test/test.json');
      expect(text, 'hi');
    });
  });
}
