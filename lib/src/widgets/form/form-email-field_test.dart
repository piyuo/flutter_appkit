import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/widgets/form/form-email-field.dart';

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
          child: SimpleEmailField(
            controller: controller,
            label: 'email',
            suggestLabel: 'suggest',
          ),
        ),
      ),
    );
  }

  group('[email-field]', () {
    testWidgets('should validate error', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      expect(find.byType(SimpleEmailField), findsOneWidget);
    });
  });
}
