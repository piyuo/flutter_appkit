import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialogs/dialogs.dart';
import 'package:libcli/src/dialogs/popup-menu.dart';

void main() {
  final GlobalKey keyBtn = GlobalKey();

  setUp(() async {
    initGlobalTranslation('en', 'US');
  });

  Widget createSample({
    required void Function(BuildContext context, Dialogs provider) onPressed,
  }) {
    return CupertinoApp(
      home: DialogOverlay(
          child: Provider(
        create: (_) => Dialogs(),
        child: Consumer<Dialogs>(
          builder: (context, provider, child) => CupertinoButton(
            key: keyBtn,
            child: Text('button'),
            onPressed: () => onPressed(context, provider),
          ),
        ),
      )),
    );
  }

  group('[dialogs]', () {
    testWidgets('should alert', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context, provider) => provider.alert(context, 'hello')),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should confirm', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context, provider) async => await provider.confirm(context, 'hello')),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert error', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(
            onPressed: (context, provider) async => await provider.alert(context, 'error message', title: 'error')),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should pop menu', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context, provider) async {
          await provider.popMenu(context, widgetKey: keyBtn, items: [
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
        createSample(onPressed: (context, provider) => provider.tooltip(context, 'hello', widgetKey: keyBtn)),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
