import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern/await.dart';
import 'package:libcli/i18n/i18n_provider.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'mock_views.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  i18n.mockInit('{"a": "A"}');

  setUp(() async {});

  group('[i18n_provider]', () {
    testWidgets('should load', (WidgetTester tester) async {
      i18n.localeID = 'en_US';
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: TestWidget(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(i18nProvider.state, isNotNull);
      expect(i18nProvider.translate('a'), 'A');
    });
  });
}

I18nProvider i18nProvider;

class TestWidget extends StatelessWidget {
  Widget widget(I18nProvider value) {
    i18nProvider = value;
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<I18nProvider>(
          create: (context) => I18nProvider('mock'),
        ),
      ],
      child: Consumer<I18nProvider>(
          builder: (context, provider, child) => Await(
                list: [provider],
                child: widget(provider),
              )),
    );
  }
}
