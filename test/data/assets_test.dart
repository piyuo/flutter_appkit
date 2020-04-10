import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/data/assets.dart' as assets;
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    assets.mockStop();
  });

  group('[assets]', () {
    test('should load string', () async {
      String asset = await assets.loadString('test/test.json');
      expect(asset, isNotNull);
      expect(asset.indexOf('A'), greaterThan(0));
    });

    test('should load json', () async {
      assets.mockString('');
      String j = await assets.loadJson('mock');
      var obj = json.decode(j);
      expect(obj, isNotNull);
    });

    test('should load string in package', () async {
      String asset =
          await assets.loadString('i18n/en/US/libcli.json', package: 'libcli');
      expect(asset, isNotEmpty);
    });

    test('should return empty if asset not exist', () async {
      String asset = await assets.loadString('not exist.json');
      expect(asset, isEmpty);
    });

    test('should mock', () async {
      Future<String> _mockLoadAssets(String assetName,
          {BuildContext context, String package}) async {
        return 'hi';
      }

      assets.mock((_mockLoadAssets));

      String asset = await assets.loadString('test/test.json');
      expect(asset, 'hi');
    });
  });
}
