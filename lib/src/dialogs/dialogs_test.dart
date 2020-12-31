import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/dialogs/dialogs.dart';
import 'package:libcli/src/dialogs/popup-menu.dart';
import 'package:libcli/src/dialogs/dialogs-mock.dart';
import 'package:libcli/src/dialogs/popup.dart';

void main() {
  final GlobalKey keyBtn = GlobalKey();

  setUp(() async {});

  Widget createSample({
    required void Function(BuildContext context) onPressed,
  }) {
    return MaterialApp(
      navigatorKey: dialogsNavigatorKey,
      home: DialogOverlay(
        child: Builder(builder: (BuildContext ctx) {
          return MaterialButton(
            key: keyBtn,
            child: Text('button'),
            onPressed: () => onPressed(ctx),
          );
        }),
      ),
    );
  }

  group('[dialogs]', () {
    testWidgets('should pop menu', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          await popMenu(context, widgetKey: keyBtn, items: [
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

    testWidgets('should tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) => tooltip(context, 'helloTooltip', widgetKey: keyBtn)),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.textContaining('helloTooltip'), findsOneWidget);
    });

    testWidgets('should toast', (WidgetTester tester) async {
      mockToast();
      await tester.pumpWidget(
        createSample(onPressed: (context) => toast(context, 'hello')),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      await expectToastAndWaitDismiss(tester);
    });
  });
}
