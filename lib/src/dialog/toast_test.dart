import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/dialog/toast.dart';
import 'package:libcli/src/dialog/dialog.dart';
import 'package:libcli/src/dialog/test.dart';

void main() {
  setUp(() async {});

  Widget sampleApp({
    required void Function(BuildContext context) onPressed,
  }) {
    return MaterialApp(
      builder: init(),
      home: Builder(builder: (BuildContext ctx) {
        return MaterialButton(
          child: Text('button'),
          onPressed: () => onPressed(ctx),
        );
      }),
    );
  }

  group('[toast]', () {
    testWidgets('should show loading and dismiss', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(onPressed: (context) async => await loading(context)),
      );
      await tester.tap(find.byType(MaterialButton));
      await tester.pump(new Duration(milliseconds: 50));
      expectToast();

      dismiss();
      await tester.pumpAndSettle();
      expectNoToast();
    });

    testWidgets('should show progress and dismiss', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(onPressed: (context) async => await progress(context, 0)),
      );
      await tester.tap(find.byType(MaterialButton));
      await tester.pump(new Duration(milliseconds: 50));
      expectToast();

      dismiss();
      await tester.pumpAndSettle();
      expectNoToast();
    });

    testWidgets('should show info toast', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(
            onPressed: (context) async => await info(context,
                autoHide: const Duration(milliseconds: 50),
                text: 'network is slow than usual',
                widget: Icon(
                  Icons.wifi,
                  size: 36,
                  color: Theme.of(context).accentColor,
                ))),
      );
      await tester.tap(find.byType(MaterialButton));
      await tester.pump(new Duration(milliseconds: 20));
      expectToast();

      dismiss();
      await tester.pumpAndSettle();
      expectNoToast();
    });

    testWidgets('should show ok toast', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(onPressed: (context) async => await ok(context, 'hi')),
      );
      await tester.tap(find.byType(MaterialButton));
      await tester.pump(new Duration(milliseconds: 50));
      expectToast();

      dismiss();
      await tester.pumpAndSettle();
      expectNoToast();
    });

    testWidgets('should show wrong toast', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(onPressed: (context) async => await wrong(context, 'something wrong')),
      );
      await tester.tap(find.byType(MaterialButton));
      await tester.pump(new Duration(milliseconds: 50));
      expectToast();

      dismiss();
      await tester.pumpAndSettle();
      expectNoToast();
    });
  });
}
