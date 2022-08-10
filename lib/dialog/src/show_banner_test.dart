import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'dialog.dart';
import 'show_banner.dart';

void main() {
  setUp(() async {});

  group('[show_banner]', () {
    testWidgets('should show content', (WidgetTester tester) async {
      BuildContext? appContext;
      await tester.pumpWidget(delta.GlobalContextSupport(
          child: MaterialApp(
        builder: init(),
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(),
              body: MaterialButton(
                  child: const Text('button'),
                  onPressed: () async {
                    appContext = context;
                    await showBanner(
                      const Text('sheetContent'),
                    );
                  }));
        }),
      )));
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(MaterialBanner), findsOneWidget);
      expect(find.text('sheetContent'), findsOneWidget);
      dismissBanner(appContext!);
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(MaterialBanner), findsNothing);
    });
  });
}
