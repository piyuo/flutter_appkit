// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/testing/testing.dart' as testing;
import 'submit.dart';

void main() {
  setUp(() {});

  group('[form.submit]', () {
    testWidgets('should click', (WidgetTester tester) async {
      bool clicked = false;
      await testing.mockApp(tester,
          child: Submit(
            key: const Key('submit'),
            label: 'submit',
            onClick: () async {
              clicked = true;
            },
          ));
      await tester.tap(find.byType(Submit));
      await tester.pumpAndSettle();
      expect(clicked, true); // second item value
    });

    testWidgets('should show loading', (WidgetTester tester) async {
      await testing.mockApp(tester,
          child: Submit(
            key: const Key('submit'),
            label: 'submit',
            showLoading: const Duration(milliseconds: 10),
            onClick: () async {
              await Future.delayed(const Duration(milliseconds: 100));
            },
          ));
      dialog.expectNoToast();
      await tester.tap(find.byKey(const Key('submit')));
      await tester.pump(const Duration(milliseconds: 50));
      dialog.expectToast();
      //wait for click finish
      await tester.pump(const Duration(milliseconds: 101));
    });
  });
}
