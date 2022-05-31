import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'email_field.dart';
import 'submit.dart';

void main() {
  setUp(() {});

  Widget testTarget(FormGroup form, ValidationMessagesFunction? validationMessages) {
    return MaterialApp(
      home: Scaffold(
        body: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              EmailField(
                formControlName: 'email',
              ),
              Submit(
                key: const Key('submit'),
                label: 'submit',
                onPressed: () async {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('[email_field]', () {
    testWidgets('should pass value to form', (WidgetTester tester) async {
      final form = fb.group({
        'email': [''],
      });

      await tester.pumpWidget(testTarget(form, null));
      await tester.enterText(find.byType(EmailField), 'a@b.c');
      await tester.pumpAndSettle();
      expect(form.control('email').value, 'a@b.c'); //email error
    });

    testWidgets('should have email required error when click submit', (WidgetTester tester) async {
      final form = fb.group({
        'email': [
          Validators.required,
        ],
      });
      await tester.pumpWidget(testTarget(
          form,
          (control) => {
                ValidationMessage.required: 'The email must not be empty',
              }));
      expect(form.hasErrors, true);
    });

    testWidgets('should have email format error', (WidgetTester tester) async {
      final form = fb.group({
        'email': [
          Validators.email,
        ],
      });
      await tester.pumpWidget(testTarget(
          form,
          (control) => {
                ValidationMessage.email: 'The email must be valid like johndoe@domain.com',
              }));
      await tester.enterText(find.byType(EmailField), 'a');
      await tester.pumpAndSettle();
      expect(form.hasErrors, true);
    });

    testWidgets('should have suggestion', (WidgetTester tester) async {
      final form = fb.group({
        'email': [
          Validators.email,
        ],
      });
      await tester.pumpWidget(testTarget(
          form,
          (control) => {
                ValidationMessage.email: 'The email must be valid like johndoe@domain.com',
              }));
      final email = form.control('email');
      email.focus();
      await tester.enterText(find.byType(EmailField), 'a@q.cc');
      email.unfocus();
      await tester.pumpAndSettle();
      expect(find.byType(RichText), findsWidgets);
    });
  });
}
