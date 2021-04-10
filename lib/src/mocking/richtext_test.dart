import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/mocking/richtext.dart';
import 'package:flutter/gestures.dart';

void main() {
  setUp(() async {});

  bool textSpanTapped = false;

  Widget target() {
    return MaterialApp(
      home: RichText(
        text: TextSpan(
          text: 'hello',
          children: <TextSpan>[
            TextSpan(
              text: 'world',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  textSpanTapped = true;
                },
            ),
          ],
        ),
      ),
    );
  }

  group('[test]', () {
    testWidgets('should find string in RichText', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(target());
        expect(find.byWidgetPredicate((widget) => containInRichText(widget, 'hello')), findsOneWidget);
        expect(find.byWidgetPredicate((widget) => containInRichText(widget, 'world')), findsOneWidget);
      });
    });

    testWidgets('should tap TextSpan', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(target());
        textSpanTapped = false;
        await tester.tap(richTextSpanFinder('world'));
        expect(textSpanTapped, true);
      });
    });
  });
}
