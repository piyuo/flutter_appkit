import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pattern.dart';
import 'package:provider/provider.dart';
import 'mock_provider.dart';
import 'mock_views.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  group('[await]', () {
    testWidgets('should wait then ready', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: TestWidget(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(MockWaitView.count, 1);
      expect(MockOkView.count, 1);
    });
  });
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MockProvider>(
          create: (context) => MockProvider(),
        ),
      ],
      child: Consumer<MockProvider>(
          builder: (context, ctrl, child) => Await(
                list: [ctrl],
                wait: MockWaitView(),
                error: MockErrorView(),
                child: MockOkView(),
              )),
    );
  }
}
