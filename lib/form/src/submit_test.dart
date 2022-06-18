// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/testing/testing.dart' as testing;
import 'submit.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  setUp(() {});
  group('[submit]', () {
    testWidgets('should click', (WidgetTester tester) async {
      bool submitted = false;
      final form = fb.group({
        'name': [''],
      });
      await testing.mockApp(tester,
          child: Scaffold(
              body: ReactiveForm(
            formGroup: form,
            child: Column(children: [
              ReactiveTextField(
                formControlName: 'name',
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  hintText: 'please input your name',
                ),
              ),
              Submit(
                label: 'submit',
                onSubmit: (context) async {
                  submitted = true;
                },
              )
            ]),
          )));

      await tester.enterText(find.byType(ReactiveTextField), 'john');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Submit));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(form.control('name').value, 'john'); // second item value
      expect(submitted, isTrue); // second item value
    });

    testWidgets('should show loading', (WidgetTester tester) async {
      final form = fb.group({
        'name': [''],
      });
      await testing.mockApp(tester,
          child: Scaffold(
              body: ReactiveForm(
            formGroup: form,
            child: Column(children: [
              ReactiveTextField(
                formControlName: 'name',
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  hintText: 'please input your name',
                ),
              ),
              Submit(
                label: 'submit',
                onSubmit: (context) async {
                  await Future.delayed(const Duration(milliseconds: 100));
                },
              )
            ]),
          )));
      dialog.expectNoToast();
      await tester.enterText(find.byType(ReactiveTextField), 'john');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Submit));
      await tester.pump(const Duration(seconds: 3));
      dialog.expectToast();
      //wait for click finish
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
