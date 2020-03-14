import 'package:flutter_test/flutter_test.dart';

import 'package:libcli/hook/assets.dart' as assets;
import 'package:libcli/hook/assets_main.dart' as assetsMain;
import 'package:libcli/hook/assets_web.dart' as assetsWeb;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    assets.get = null;
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
}
