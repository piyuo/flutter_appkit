// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/testing/testing.dart' as testing;
import 'submit.dart';

void main() {
  setUp(() {});

  group('[submit]', () {
    testWidgets('should click', (WidgetTester tester) async {
      bool clicked = false;
      final formKey = GlobalKey<FormState>();
      await testing.mockApp(tester,
          child: Form(
              key: formKey,
              child: Submit(
                key: const Key('Button'),
                formKey: formKey,
                label: 'button',
                onPressed: () async {
                  clicked = true;
                },
              )));
      await tester.tap(find.byType(Submit));
      await tester.pumpAndSettle();
      expect(clicked, true); // second item value
    });

    testWidgets('should show loading', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      await testing.mockApp(tester,
          child: Form(
              key: formKey,
              child: Submit(
                key: const Key('Button'),
                formKey: formKey,
                label: 'button',
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 100));
                },
              )));
      dialog.expectNoToast();
      await tester.tap(find.byKey(const Key('Button')));
      await tester.pump(const Duration(milliseconds: 50));
      dialog.expectToast();
      //wait for click finish
      await tester.pump(const Duration(milliseconds: 101));
    });
  });
}
