import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/dialog/tooltip.dart';
import 'package:libcli/src/dialog/popup-menu.dart';

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
          child: Text('button'),
          onPressed: () => onPressed(ctx),
        );
      }),
    );
  }

  group('[tooltip]', () {
    testWidgets('should show tool menu', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(onPressed: (context) async {
          await tool(context, widgetKey: keyBtn, items: [
            MenuItem(
                id: 'home',
                text: 'Home',
                widget: Icon(
                  Icons.home,
                  color: Colors.white,
                ))
          ]);
        }),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.byType(MenuItemWidget), findsOneWidget);
    });

    testWidgets('should show tip', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(onPressed: (context) => tip(context, 'helloTooltip', widgetKey: keyBtn)),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.textContaining('helloTooltip'), findsOneWidget);
    });
  });
}
