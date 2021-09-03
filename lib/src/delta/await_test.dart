import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'async-provider.dart';
import 'await.dart';

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
                [ctrl],
                progress: MockWaitView(),
                error: MockErrorView(),
                child: MockOkView(),
              )),
    );
  }
}

class MockWaitView extends StatelessWidget {
  static int count = 0;
  @override
  Widget build(BuildContext context) {
    count++;
    return Text('');
  }
}

class MockErrorView extends StatelessWidget {
  static int count = 0;

  @override
  Widget build(BuildContext context) {
    count++;
    return Text('');
  }
}

class MockOkView extends StatelessWidget {
  static int count = 0;
  @override
  Widget build(BuildContext context) {
    count++;
    return Text('');
  }
}

class MockProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1), () {});
  }
}
