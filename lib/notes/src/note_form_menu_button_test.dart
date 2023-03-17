import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  setUp(() async {});

  group('[NoteFormMenuButton]', () {
    testWidgets('should show menu', (WidgetTester tester) async {
      bool click = false;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext ctx) {
          return MaterialButton(
            child: const Text('button'),
            onPressed: () {
              click = true;
            },
          );
        }),
      ));
      await tester.tap(find.byType(MaterialButton));
//      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      expect(click, isTrue);
    });
  });
}
