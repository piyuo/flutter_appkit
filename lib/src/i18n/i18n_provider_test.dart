import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/delta.dart' as delta;
import 'package:libcli/src/i18n/i18n.dart';
import 'package:libcli/src/i18n/i18n_provider.dart';
import 'package:libcli/src/i18n/test.dart';
import 'package:libcli/asset.dart' as asset;
import 'package:libcli/testing.dart' as testing;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // ignore: invalid_use_of_visible_for_testing_member
    asset.mock('{"a": "A"}');
  });

  tearDown(() async {
    // ignore: invalid_use_of_visible_for_testing_member
    asset.mockDone();
  });

  group('[i18n-provider]', () {
    test('should get translation', () async {
      var translation = await getTranslation(fileName: 'any');
      expect(translation.isEmpty, false);
      expect(translation['a'], 'A');
    });

    test('should get translation on file2', () async {
      var translation = await getTranslation(fileName: 'any', fileName2: 'any');
      expect(translation.isEmpty, false);
      expect(translation['a'], 'A');
    });

    testWidgets('should load', (WidgetTester tester) async {
      setLocale(testing.Context(), const Locale('en', 'US'));
      await tester.pumpWidget(const MaterialApp(
        home: TestWidget(),
      ));
      await tester.pumpAndSettle();
      expect(TestWidget.i18nProvider!.translate('a'), 'A');
    });
  });
}

class TestWidget extends StatelessWidget {
  static I18nProvider? i18nProvider;

  const TestWidget({Key? key}) : super(key: key);

  Widget widget(I18nProvider value) {
    i18nProvider = value;
    return const Text('');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<I18nProvider>(
          create: (context) => I18nProvider(fileName: 'mock'),
        ),
        ChangeNotifierProvider<MockProvider>(
          create: (context) => MockProvider(),
        ),
      ],
      child: Consumer2<I18nProvider, MockProvider>(
          builder: (context, i18n, mock, child) => delta.Await(
                [i18n, mock],
                child: widget(i18n),
              )),
    );
  }
}
