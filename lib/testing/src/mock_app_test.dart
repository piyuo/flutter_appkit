import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'mock_app.dart';

void main() {
  group('[testing.mock_app]', () {
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
