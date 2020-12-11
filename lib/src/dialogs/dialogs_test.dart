import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialogs/dialogs.dart';
import 'package:libcli/src/dialogs/popup-menu.dart';
import 'package:libcli/src/dialogs/dialogs-mock.dart';

void main() {
  final GlobalKey keyBtn = GlobalKey();

  setUp(() async {
    initGlobalTranslation('en', 'US');
  });

  Widget createSample({
    required void Function(BuildContext context) onPressed,
  }) {
    return CupertinoApp(
      navigatorKey: dialogsNavigatorKey,
      home: DialogOverlay(
        child: Builder(builder: (BuildContext ctx) {
          return CupertinoButton(
            key: keyBtn,
            child: Text('button'),
            onPressed: () => onPressed(ctx),
          );
        }),
      ),
    );
  }

  group('[dialogs]', () {
    testWidgets('should alert', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) => alert(context, 'hello')),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should confirm', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async => await confirm(context, 'hello')),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert error', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async => await alert(context, 'error message', title: 'error')),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should pop menu', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          await popMenu(context, widgetKey: keyBtn, items: [
            MenuItem(
                id: 'home',
                text: 'Home',
                widget: Icon(
                  CupertinoIcons.home,
                  color: CupertinoColors.white,
                ))
          ]);
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(MenuItemWidget), findsOneWidget);
    });

    testWidgets('should tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) => tooltip(context, 'hello', widgetKey: keyBtn)),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('should toast', (WidgetTester tester) async {
      mockToast();
      await tester.pumpWidget(
        createSample(onPressed: (context) => toast(context, 'hello')),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      await expectToastAndWaitDismiss(tester);
    });
  });
}
