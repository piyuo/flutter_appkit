import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern/await.dart';
import 'package:libcli/i18n/i18n_provider.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'mock_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  i18n.mockInit('{"a": "A"}');

  group('[i18n_await]', () {
    testWidgets('should load i18n', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: TestWidget(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(TestWidget.i18n, isNotNull);
      expect(TestWidget.i18n.translate('a'), 'A');
    });
  });
}

class TestWidget extends StatelessWidget {
  static I18nProvider i18n;

  Widget widget(I18nProvider value) {
    i18n = value;
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MockProvider>(
          create: (context) => MockProvider(),
        ),
        ChangeNotifierProvider<I18nProvider>(
          create: (context) => I18nProvider('mock'),
        ),
      ],
      child: Consumer2<MockProvider, I18nProvider>(
          builder: (context, mock, i18n, child) => Await(
                list: [mock, i18n],
                child: widget(i18n),
              )),
    );
  }
}
