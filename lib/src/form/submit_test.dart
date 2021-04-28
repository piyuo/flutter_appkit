import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'submit.dart';

void main() {
  final _keyForm = GlobalKey<FormState>();

  bool clicked = false;

  setUp(() {
    clicked = false;
  });

  Widget app() {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _keyForm,
          child: Column(
            children: [
              Submit(
                'submit',
                onClick: () async => clicked = true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('[submit]', () {
    testWidgets('should click', (WidgetTester tester) async {
      await tester.pumpWidget(app());
      await tester.tap(find.byType(Submit));
      await tester.pumpAndSettle();
      expect(clicked, true); // second item value
    });
  });
}
