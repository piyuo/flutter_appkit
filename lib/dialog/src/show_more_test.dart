import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'dialog.dart';
import 'show_more.dart';

void main() {
  final GlobalKey btnShowMore = GlobalKey();

  setUp(() async {});

  group('[show_more]', () {
    testWidgets('should show content', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        builder: init(),
        home: Builder(builder: (BuildContext context) {
          return MaterialButton(
              key: btnShowMore,
              child: const Text('button'),
              onPressed: () {
                var rect = delta.getWidgetGlobalRect(btnShowMore);
                showMore(
                  context,
                  size: const Size(180, 120),
                  targetRect: rect,
                  child: const Text('sheetContent'),
                );
              });
        }),
      ));
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.text('sheetContent'), findsOneWidget);
    });
  });
}
