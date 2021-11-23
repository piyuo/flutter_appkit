// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'alert.dart';

void main() {
  final GlobalKey keyBtn = GlobalKey();

  setUp(() async {});

  Widget createSample({
    required void Function(BuildContext context) onPressed,
  }) {
    return Builder(
        builder: (BuildContext context) => MaterialButton(
              key: keyBtn,
              child: const Text('button'),
              onPressed: () => onPressed(context),
            ));
  }

  group('[dialog.alert]', () {
    testWidgets('should alert with close', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) => alert(context, 'hello')),
      );

      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      //tap close
      await tester.tap(find.byKey(keyAlertButtonCancel));
      await tester.pumpAndSettle();
      expect(
        find.byType(Dialog),
        findsNothing,
      );
    });

    testWidgets('should alert with cancel', (WidgetTester tester) async {
      bool? result;
      await testing.mockApp(
        tester,
        child: createSample(
            onPressed: (context) async => result = await alert(
                  context,
                  'hello',
                  yes: 'ok',
                  cancel: 'cancel',
                )),
      );

      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      expect(result, null);
      //tap close
      await tester.tap(find.byKey(keyAlertButtonCancel));
      await tester.pumpAndSettle();
      expect(
        find.byType(Dialog),
        findsNothing,
      );
      expect(result, null);
    });

    testWidgets('should alert with ok', (WidgetTester tester) async {
      bool? result;
      await testing.mockApp(
        tester,
        child: createSample(
            onPressed: (context) async => result = await alert(
                  context,
                  'hello',
                  yes: 'ok',
                  cancel: 'cancel',
                )),
      );
      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      //tap ok
      await tester.tap(find.byKey(keyAlertButtonYes));
      await tester.pumpAndSettle();
      expect(
        find.byType(Dialog),
        findsNothing,
      );
      expect(result, true);
    });

    testWidgets('should alert with yes no', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(
            onPressed: (context) async => await alert(
                  context,
                  'hello',
                  yes: 'yes',
                  cancel: 'no',
                )),
      );

      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert error', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async => await alert(context, 'error message', title: 'error')),
      );

      expect(find.byType(MaterialButton), findsOneWidget);
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });
  });
}
