import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'wait.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  group('[wait]', () {
    testWidgets('should wait then ready', (WidgetTester tester) async {
      MockLoadingView.count = 0;
      MockErrorView.count = 0;
      MockReadyView.count = 0;
      await tester.pumpWidget(MaterialApp(
        home: Wait(
          future: () async {},
          loading: const MockLoadingView(),
          error: const MockErrorView(),
          child: const MockReadyView(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(MockLoadingView.count, 1);
      expect(MockErrorView.count, 0);
      expect(MockReadyView.count, 1);
    });

    testWidgets('should wait then error', (WidgetTester tester) async {
      MockLoadingView.count = 0;
      MockErrorView.count = 0;
      MockReadyView.count = 0;
      await tester.pumpWidget(MaterialApp(
        home: Wait(
          future: () async {
            throw Exception();
          },
          loading: const MockLoadingView(),
          error: const MockErrorView(),
          child: const MockReadyView(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(MockLoadingView.count, 1);
      expect(MockErrorView.count, 1);
      expect(MockReadyView.count, 0);
    });
  });
}

class MockLoadingView extends StatelessWidget {
  static int count = 0;

  const MockLoadingView({Key? key}) : super(key: key);
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

class MockReadyView extends StatelessWidget {
  static int count = 0;

  const MockReadyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    count++;
    return const Text('');
  }
}
