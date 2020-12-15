import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/widgets/form/form-text-field.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  final _keyForm = GlobalKey<FormState>();
  final controller = TextEditingController();

  Widget testTarget() {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _keyForm,
          child: FormTextField(
            controller: controller,
            label: 'name',
            require: true,
          ),
        ),
      ),
    );
  }

  group('[form-text-field]', () {
    testWidgets('should validate error required', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      expect(_keyForm.currentState!.validate(), false);
      await tester.pumpAndSettle();
      expect(find.textContaining('required'), findsOneWidget); //email error
    });
  });
}
