import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'loading_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  group('[loading_screen]', () {
    testWidgets('should wait then ready', (WidgetTester tester) async {
      MockLoadingView.count = 0;
      MockReadyView.count = 0;
      await tester.pumpWidget(MaterialApp(
        home: LoadingScreen(
          future: () async {},
          loadingWidgetBuilder: () => const MockLoadingView(),
          builder: () => const MockReadyView(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(MockLoadingView.count, 1);
      expect(MockReadyView.count, 1);
    });

    testWidgets('should wait then error', (WidgetTester tester) async {
      MockLoadingView.count = 0;
      MockReadyView.count = 0;
      await tester.pumpWidget(MaterialApp(
        home: LoadingScreen(
          future: () async {
            throw Exception();
          },
          loadingWidgetBuilder: () => const MockLoadingView(),
          builder: () => const MockReadyView(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(MockLoadingView.count, 1);
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

class MockReadyView extends StatelessWidget {
  static int count = 0;

  const MockReadyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    count++;
    return const Text('');
  }
}
