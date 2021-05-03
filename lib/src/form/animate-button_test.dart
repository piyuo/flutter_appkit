import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/form/animate-button.dart';

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
              AnimateButton(
                'submit',
                onClick: () async => clicked = true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('[animate-button]', () {
    testWidgets('should click', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      await tester.tap(find.byType(AnimateButton));
      await tester.pumpAndSettle();
      expect(clicked, true); // second item value
    });
  });
}
