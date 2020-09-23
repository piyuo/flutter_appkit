import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'mock-provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // ignore: invalid_use_of_visible_for_testing_member
  mockI18n(Locale('en', 'US'), '{"a": "A"}');

  setUp(() async {});

  group('[i18n-provider]', () {
    test('should getTranslation', () async {
      var translation = await getTranslation('any');
      expect(translation, isNotNull);
      expect(translation['a'], 'A');
    });

    testWidgets('should load', (WidgetTester tester) async {
      locale = Locale('en', 'US');
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: TestWidget(),
        ),
      ));
      await tester.pumpAndSettle();
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
        ChangeNotifierProvider<MockProvider>(
          create: (context) => MockProvider(),
        ),
      ],
      child: Consumer2<I18nProvider, MockProvider>(
          builder: (context, i18n, mock, child) => Await(
                list: [i18n, mock],
                child: widget(i18n),
              )),
    );
  }
}
