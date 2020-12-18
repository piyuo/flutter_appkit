import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/test/test.dart';

void main() {
  setUp(() async {});

  Widget target() {
    return MaterialApp(
      home: RichText(
        text: TextSpan(
          text: 'hello',
          children: <TextSpan>[
            TextSpan(text: 'world'),
          ],
        ),
      ),
    );
  }

  group('[test]', () {
    testWidgets('should find string in rich text', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(target());
        expect(find.byWidgetPredicate((widget) => findStringInRichText(widget, 'hello')),
            findsOneWidget); // show email address request sent
        expect(find.byWidgetPredicate((widget) => findStringInRichText(widget, 'world')),
            findsOneWidget); // show email address request sent
      });
    });

    test('should create mock context', () async {
      MockBuildContext context = MockBuildContext();
      expect(context.toString(), isNotEmpty);
    });
  });
}
