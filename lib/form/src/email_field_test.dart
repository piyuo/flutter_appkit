import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'email_field.dart';
import 'button.dart';

void main() {
  final _keyForm = GlobalKey<FormState>();

  final controller = TextEditingController();

  final focusNode = FocusNode();

  final dummyController = TextEditingController();

  final dummyFocusNode = FocusNode();

  setUp(() {
    controller.text = '';
  });

  Widget testTarget() {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _keyForm,
          child: Column(
            children: [
              EmailField(
                key: const Key('test-email'),
                controller: controller,
                focusNode: focusNode,
                label: 'email',
              ),
              TextField(
                controller: dummyController,
                focusNode: dummyFocusNode,
              ),
              Button(
                key: const Key('submit'),
                label: 'submit',
                form: _keyForm,
                onClick: () async {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('[email-field]', () {
    testWidgets('should pass value to controller', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      await tester.enterText(find.byType(EmailField), 'a@b.c');
      await tester.pumpAndSettle();
      expect(controller.text, 'a@b.c'); //email error
    });

    testWidgets('should have email empty error when click submit', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      await tester.tap(find.byType(Button));
      await tester.pumpAndSettle();
      expect(find.textContaining('johndoe@domain.com'), findsOneWidget); //email error
    });

    testWidgets('should have email empty error', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      expect(_keyForm.currentState!.validate(), false);
      await tester.pumpAndSettle();
      expect(find.textContaining('johndoe@domain.com'), findsOneWidget); //email error
    });

    testWidgets('should have email format error', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      await tester.enterText(find.byType(EmailField), 'a@b');
      expect(_keyForm.currentState!.validate(), false);
      await tester.pumpAndSettle();
      expect(find.textContaining('johndoe@domain.com'), findsOneWidget); //email error
    });

    testWidgets('should have suggestion', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      focusNode.requestFocus();
      await tester.enterText(find.byType(EmailField), 'a@q.cc');
      expect(_keyForm.currentState!.validate(), true);
      dummyFocusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(find.byType(RichText), findsWidgets);
    });
  });
}
