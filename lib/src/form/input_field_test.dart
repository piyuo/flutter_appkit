import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'input_field.dart';

void main() {
  final _keyForm = GlobalKey<FormState>();

  final controller = TextEditingController();

  setUp(() {
    controller.text = '';
  });

  Widget testTarget() {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _keyForm,
          child: InputField(
            key: const Key('test-input'),
            controller: controller,
            label: 'name',
            maxLength: 10,
            minLength: 2,
            require: 'required',
          ),
        ),
      ),
    );
  }

  group('[input-field]', () {
    testWidgets('should pass value to controller', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      await tester.enterText(find.byType(TextField), 'hi');
      await tester.pumpAndSettle();
      expect(controller.text, 'hi'); //email error
    });

    testWidgets('should have required error', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      expect(_keyForm.currentState!.validate(), false);
      await tester.pumpAndSettle();
      expect(find.textContaining('required'), findsOneWidget); //email error
    });

    testWidgets('should not exceed max length', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      await tester.enterText(find.byType(InputField), '12345678901');
      await tester.pumpAndSettle();
      expect(controller.text, '1234567890'); //email error
    });

    testWidgets('should have min length error', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      await tester.enterText(find.byType(InputField), '1');
      await tester.pumpAndSettle();
      expect(find.textContaining('at least'), findsOneWidget); //email error
    });
  });
}
