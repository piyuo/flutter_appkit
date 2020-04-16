import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/asset.dart' as asset;
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    asset.mockAssetsStop();
  });

  group('[asset]', () {
    test('should load string', () async {
      String text = await asset.loadString('test/test.json');
      expect(text, isNotNull);
      expect(text.indexOf('A'), greaterThan(0));
    });

    test('should load json', () async {
      asset.mockAssetsByString('');
      String j = await asset.loadJson('mock');
      var obj = json.decode(j);
      expect(obj, isNotNull);
    });

    test('should load string in package', () async {
      String text =
          await asset.loadString('i18n/en/US/lib.json', package: 'libcli');
      expect(text, isNotEmpty);
    });

    test('should return empty if asset not exist', () async {
      String text = await asset.loadString('not exist.json');
      expect(text, isEmpty);
    });

    test('should mock', () async {
      Future<String> _mockLoadAssets(String assetName,
          {BuildContext context, String package}) async {
        return 'hi';
      }

      asset.mockAssets((_mockLoadAssets));

      String text = await asset.loadString('test/test.json');
      expect(text, 'hi');
    });
  });
}
