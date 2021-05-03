import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:libcli/src/module/mock-provider.dart';
import 'package:libcli/src/module/mock_views.dart';
import 'package:libcli/src/module/await.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  group('[await]', () {
    testWidgets('should wait then ready', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestWidget(),
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
                progress: MockWaitView(),
                error: MockErrorView(),
                child: MockOkView(),
              )),
    );
  }
}
