import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'i18n_provider.dart';
import 'test.dart';
import 'package:libcli/assets/assets.dart' as asset;

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

  group('[i18n-await]', () {
    testWidgets('should load i18n', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
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

  const TestWidget({Key? key}) : super(key: key);

  Widget widget(I18nProvider value) {
    i18n = value;
    return const Text('');
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
          builder: (context, mock, i18n, child) => delta.Await(
                [mock, i18n],
                child: widget(i18n),
              )),
    );
  }
}
