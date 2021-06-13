import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/types.dart' as types;
import 'check.dart';

void main() {
  final _keyForm = GlobalKey<FormState>();

  final controller = types.BoolController();

  setUp(() {
    controller.value = false;
  });

  Widget app() {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _keyForm,
          child: Column(
            children: [
              Check(
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('[checkbox]', () {
    testWidgets('should pass value to controller', (WidgetTester tester) async {
      await tester.pumpWidget(app());
      expect(controller.value, false); // first item value
      await tester.tap(find.byType(Check));
      await tester.pumpAndSettle();
      expect(controller.value, true); // second item value
    });
  });
}
