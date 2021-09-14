import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'popup.dart';

void main() {
  final GlobalKey keyBtn = GlobalKey();

  setUp(() async {});

  Widget sampleApp({
    required void Function(BuildContext context) onPressed,
  }) {
    return MaterialApp(
      home: Builder(builder: (BuildContext ctx) {
        return MaterialButton(
          key: keyBtn,
          child: const Text('button'),
          onPressed: () => onPressed(ctx),
        );
      }),
    );
  }

  group('[popup]', () {
    testWidgets('should show', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(
          onPressed: (context) {
            var rect = getWidgetGlobalRect(keyBtn);
            popup(context,
                rect: Rect.fromLTWH(rect.left, rect.bottom, rect.width, 200),
                child: Container(
                  color: Colors.green,
                  child: const Center(
                    child: Text(
                      'hello',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ));
          },
        ),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.textContaining('hello'), findsOneWidget);
    });
  });
}
