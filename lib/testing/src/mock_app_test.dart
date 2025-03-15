import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'mock_app.dart';

void main() {
  group('[testing.mock_app]', () {
    test('should create mock BuildContext', () async {
      Context ctx = Context();
      expect(ctx, isNotNull);
    });

    testWidgets('should scale down test font', (WidgetTester tester) async {
      useTestFont(tester);
    });

    testWidgets('should mock app', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await mockApp(
          tester,
          child: const Text('hi'),
        );
        expect(find.textContaining('hi'), findsOneWidget); //email error
      });
    });
  });
}
