import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dialog.dart';
import 'show_slide_sheet.dart';

void main() {
  setUp(() async {});

  group('[show_slide_sheet]', () {
    testWidgets('should show content', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        builder: init(),
        home: Builder(builder: (BuildContext context) {
          return MaterialButton(
            child: const Text('button'),
            onPressed: () => showSlideSheet(
              context,
              constraints: const BoxConstraints(maxWidth: 500),
              builder: (context, scrollController) => ListView(
                controller: scrollController,
                children: const [
                  Text('sheetContent'),
                ],
              ),
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
