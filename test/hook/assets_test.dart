import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:libcli/hook/assets.dart' as assets;
import 'package:libcli/hook/assets_main.dart' as assetsMain;
import 'package:libcli/hook/assets_web.dart' as assetsWeb;

/*
class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key == 'resources/test')
      return ByteData.view(
          Uint8List.fromList(utf8.encode('Hello World!')).buffer);
    return null;
  }
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    assets.load('i18n/mock_en_US.json');
    //String asset = await assets.load('i18n/mock_en_US.json');
    //expect(asset, isNotNull);
    return Text('test');
  }
}
*/
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
//    assets.load = null;
  });

  group('assets', () {
    testWidgets('should load', (WidgetTester tester) async {
      expect(assets.get, null);
      assetsWeb.inject();
      expect(assets.get, isNotNull);
      String asset = await assets.get('i18n/mock_en_US.json');
      expect(asset, isNotNull);
      expect(asset.indexOf('mock'), greaterThan(0));

      assets.get = null;
      assetsMain.inject();
      expect(assets.get, isNotNull);
      asset = await assets.get('i18n/mock_en_US.json');
      expect(asset, isNotNull);
      expect(asset.indexOf('mock'), greaterThan(0));
    });
  });

/*
  testWidgets('should load', (WidgetTester tester) async {
    String asset = await assets.load('i18n/mock_en_US.json');
    expect(asset, isNotNull);

    await tester.pumpWidget(
      MaterialApp(
        home: DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: TestWidget(),
        ),
      ),
    );
  });
*/
//  test('should init create base.instance', () async {
  // });
}
