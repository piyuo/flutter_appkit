import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
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
      String text = await loadString('test/test.json');
      expect(text, isNotNull);
      expect(text.indexOf('A'), greaterThan(0));
    });

    test('should load json', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      mockAssetsByString('');
      String j = await loadJson('mock');
      var obj = json.decode(j);
      expect(obj, isNotNull);
    });

    test('should load map', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      mockAssetsByString('{}');
      Map map = await loadMap('');
      expect(map, isNotNull);
    });

    test('should load string in package', () async {
      String text =
          await loadString('i18n/dialog_en-US.json', package: 'libcli');
      expect(text, isNotEmpty);
    });

    test('should return empty if asset not exist', () async {
      String text = await loadString('not exist.json');
      expect(text, isEmpty);
    });

    test('should mock', () async {
      Future<String> _mockLoadAssets(String assetName,
          {BuildContext context, String package}) async {
        return 'hi';
      }

      // ignore: invalid_use_of_visible_for_testing_member
      mockAssets((_mockLoadAssets));

      String text = await loadString('test/test.json');
      expect(text, 'hi');
    });
  });
}
