import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/module.dart';
import 'package:libcli/i18n.dart';
import 'mock-provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // ignore: invalid_use_of_visible_for_testing_member
  mockI18n(Locale('en', 'US'), '{"a": "A"}');

  group('[i18n-await]', () {
    testWidgets('should load i18n', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestWidget(),
      ));
      await tester.pumpAndSettle();
      expect(TestWidget.i18n, isNotNull);
      expect(TestWidget.i18n!.translate('a'), 'A');
    });
  });
}

class TestWidget extends StatelessWidget {
  static I18nProvider? i18n;

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
          create: (context) => I18nProvider(fileName: 'mock'),
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
