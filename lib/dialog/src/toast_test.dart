import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'toast.dart';
import 'dialog.dart';
import 'test.dart';

void main() {
  setUp(() async {});

  Widget sampleApp({
    required void Function(BuildContext context) onPressed,
  }) {
    return Provider(
      create: (_) => DialogProvider(),
      child: Consumer<DialogProvider>(
        builder: (context, dialogProvider, _) => MaterialApp(
          builder: dialogProvider.init(),
          home: Builder(builder: (BuildContext ctx) {
            return MaterialButton(
              child: const Text('button'),
              onPressed: () => onPressed(ctx),
            );
          }),
        ),
      ),
    );
  }

  group('[toast]', () {
    testWidgets('should show loading and dismiss', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(onPressed: (context) async => await toastLoading(context)),
      );
      await tester.tap(find.byType(MaterialButton));
      await tester.pump(const Duration(milliseconds: 50));
      expectToast();

      dismiss();
      await tester.pumpAndSettle();
      expectNoToast();
    });

    testWidgets('should show progress and dismiss', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(onPressed: (context) async => await toastProgress(context, 0)),
      );
      await tester.tap(find.byType(MaterialButton));
      await tester.pump(const Duration(milliseconds: 50));
      expectToast();

      dismiss();
      await tester.pumpAndSettle();
      expectNoToast();
    });

    testWidgets('should show info toast', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(
            onPressed: (context) async => await toastInfo(context,
                autoHide: const Duration(milliseconds: 50),
                text: 'network is slow than usual',
                widget: const Icon(
                  Icons.wifi,
                  size: 36,
                  color: Colors.red,
                ))),
      );
      await tester.tap(find.byType(MaterialButton));
      await tester.pump(const Duration(milliseconds: 20));
      expectToast();

      dismiss();
      await tester.pumpAndSettle();
      expectNoToast();
    });

    testWidgets('should show ok toast', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(onPressed: (context) async => await toastOK(context, text: 'hi')),
      );
      await tester.tap(find.byType(MaterialButton));
      await tester.pump(const Duration(milliseconds: 50));
      expectToast();

      dismiss();
      await tester.pumpAndSettle();
      expectNoToast();
    });

    testWidgets('should show wrong toast', (WidgetTester tester) async {
      await tester.pumpWidget(
        sampleApp(onPressed: (context) async => await toastError(context, 'something wrong')),
      );
      await tester.tap(find.byType(MaterialButton));
      await tester.pump(const Duration(milliseconds: 50));
      expectToast();

      dismiss();
      await tester.pumpAndSettle();
      expectNoToast();
    });
  });
}
