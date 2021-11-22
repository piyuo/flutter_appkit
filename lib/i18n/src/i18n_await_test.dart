// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'test.dart';
import 'package:libcli/assets/assets.dart' as asset;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    asset.mock('{"a": "A"}');
  });

  tearDown(() async {
    asset.mockDone();
  });

  group('[i18n-await]', () {
    testWidgets('should load i18n', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: TestWidget(),
      ));
      await tester.pumpAndSettle();
      expect(TestWidget.mock, isNotNull);
    });
  });
}

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  static MockProvider? mock;

  Widget widget(MockProvider value) {
    mock = value;
    return const Text('');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MockProvider>(
          create: (context) => MockProvider(),
        ),
      ],
      child: Consumer<MockProvider>(
          builder: (context, mock, child) => delta.Await(
                [mock],
                child: widget(mock),
              )),
    );
  }
}
