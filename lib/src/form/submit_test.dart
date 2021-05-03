import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/dialog.dart' as dialog;
import 'submit.dart';

void main() {
  final _keyForm = GlobalKey<FormState>();

  setUp(() {});

  Widget app(Widget widget) {
    return MaterialApp(
      builder: dialog.init(),
      home: Scaffold(
        body: Form(
          key: _keyForm,
          child: widget,
        ),
      ),
    );
  }

  group('[submit]', () {
    testWidgets('should click', (WidgetTester tester) async {
      bool clicked = false;
      var widget = Submit(
        'submit',
        onClick: () {
          clicked = true;
        },
      );
      await tester.pumpWidget(app(widget));
      await tester.tap(find.byType(Submit));
      await tester.pumpAndSettle();
      expect(clicked, true); // second item value
    });

    testWidgets('should show loading', (WidgetTester tester) async {
      var widget = Submit(
        'submit',
        showLoading: const Duration(milliseconds: 10),
        onClick: () async {
          await Future.delayed(Duration(milliseconds: 100));
        },
      );
      await tester.pumpWidget(app(widget));
      dialog.expectNoToast();
      await tester.tap(find.byType(Submit));
      await tester.pump(Duration(milliseconds: 50));
      dialog.expectToast();
      //wait for click finish
      await tester.pump(Duration(milliseconds: 101));
    });
  });
}
