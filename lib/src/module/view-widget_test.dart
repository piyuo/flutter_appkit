import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/module.dart';

class SampleViewModel extends ViewProvider {}

class SampleViewWidget extends ViewWidget<SampleViewModel> {
  @protected
  createProvider(BuildContext context) => SampleViewModel();

  @override
  Widget createWidget(BuildContext context) => Container();

  SampleViewWidget() : super(i18nFilename: '');
}

void main() {
  Widget target() {
    return MaterialApp(
      home: SampleViewWidget(),
    );
  }

  group('[view-widget]', () {
    testWidgets('should set viewWidgetProviderInstanceForTest in test', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(target());
        expect(viewWidgetProviderInstanceForTest is SampleViewModel, true);
      });
    });
  });
}
