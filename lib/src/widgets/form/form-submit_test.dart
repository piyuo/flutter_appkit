import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/widgets/form/form-submit.dart';

void main() {
  final _keyForm = GlobalKey<FormState>();

  bool clicked = false;

  setUp(() {
    clicked = false;
  });

  Widget testTarget() {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _keyForm,
          child: Column(
            children: [
              FormSubmit(
                'submit',
                onClick: () async => clicked = true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('[form-submit]', () {
    testWidgets('should click', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      await tester.tap(find.byType(FormSubmit));
      await tester.pumpAndSettle();
      expect(clicked, true); // second item value
    });
  });
}
