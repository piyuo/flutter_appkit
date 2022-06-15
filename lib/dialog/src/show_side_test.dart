import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dialog.dart';
import 'show_side.dart';

void main() {
  setUp(() async {});

  group('[show_side]', () {
    testWidgets('should show content', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        builder: init(),
        home: Builder(builder: (BuildContext context) {
          return MaterialButton(
            child: const Text('button'),
            onPressed: () => showSide(
              context,
              constraints: const BoxConstraints(maxWidth: 500),
              child: const Text('sheetContent'),
            ),
          );
        }),
      ));
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.text('sheetContent'), findsOneWidget);
    });
  });
}
