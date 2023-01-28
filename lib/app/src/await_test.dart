import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'await.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  group('[await]', () {
    testWidgets('should wait then ready', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: TestWidget(),
      ));
      await tester.pumpAndSettle();
      expect(MockWaitView.count, 1);
      expect(MockOkView.count, 1);
    });
  });
}

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

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
                progress: const MockWaitView(),
                error: const MockErrorView(),
                child: const MockOkView(),
              )),
    );
  }
}

class MockWaitView extends StatelessWidget {
  static int count = 0;

  const MockWaitView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    count++;
    return const Text('');
  }
}

class MockErrorView extends StatelessWidget {
  static int count = 0;

  const MockErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    count++;
    return const Text('');
  }
}

class MockOkView extends StatelessWidget {
  static int count = 0;

  const MockOkView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    count++;
    return const Text('');
  }
}

class MockProvider extends delta.AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
  }
}
