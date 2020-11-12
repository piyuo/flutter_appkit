import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/module.dart';
import 'package:libcli/i18n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // ignore: invalid_use_of_visible_for_testing_member
  mockI18n(Locale('en', 'US'), '{"a": "A"}');

  group('[i18n-extension]', () {
    testWidgets('should translate ' '.i18n(context)', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: TestWidget(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(LocaleWidget.value, 'A');
    });
  });
}

class LocaleWidget extends StatelessWidget {
  static String value = '';

  @override
  Widget build(BuildContext context) {
    value = 'a'.i18n(context);
    return Text(value);
  }
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<I18nProvider>(
          create: (context) => I18nProvider(fileName: 'mock'),
        ),
      ],
      child: Consumer<I18nProvider>(
          builder: (context, i18n, child) => Await(
                list: [i18n],
                child: LocaleWidget(),
              )),
    );
  }
}
