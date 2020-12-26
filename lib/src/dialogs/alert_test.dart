import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/dialogs/dialogs.dart';
import 'package:libcli/src/dialogs/alert.dart';

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

  group('[alert]', () {
    testWidgets('should alert with close', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) => alert(context, 'hello')),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      //tap close
      await tester.tap(find.byKey(keyAlertButtonFalse));
      await tester.pumpAndSettle();
      expect(
        find.byType(AlertDialog),
        findsNothing,
      );
    });

    testWidgets('should alert with cancel', (WidgetTester tester) async {
      var result = null;
      await tester.pumpWidget(
        createSample(
            onPressed: (context) async => result = await alert(context, 'hello', buttonType: ButtonType.okCancel)),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(result, null);
      //tap close
      await tester.tap(find.byKey(keyAlertButtonFalse));
      await tester.pumpAndSettle();
      expect(
        find.byType(AlertDialog),
        findsNothing,
      );
      expect(result, false);
    });

    testWidgets('should alert with ok', (WidgetTester tester) async {
      var result = null;
      await tester.pumpWidget(
        createSample(
            onPressed: (context) async => result = await alert(context, 'hello', buttonType: ButtonType.okCancel)),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      //tap ok
      await tester.tap(find.byKey(keyAlertButtonTrue));
      await tester.pumpAndSettle();
      expect(
        find.byType(AlertDialog),
        findsNothing,
      );
      expect(result, true);
    });

    testWidgets('should alert with yes no', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async => await alert(context, 'hello', buttonType: ButtonType.yesNo)),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should alert error', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async => await alert(context, 'error message', title: 'error')),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
