import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'view-provider.dart';
import 'view-widget.dart';

class SampleViewModel extends ViewProvider {}

class SampleViewWidget extends ViewWidget<SampleViewModel> {
  @override
  createProvider(BuildContext context) => SampleViewModel();

  @override
  Widget createWidget(BuildContext context) => Container();

  const SampleViewWidget({Key? key}) : super(key: key, i18nFile: '');
}

void main() {
  Widget target() {
    return const MaterialApp(
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
