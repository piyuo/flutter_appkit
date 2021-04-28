import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'check.dart';
import 'package:libcli/src/widgets/controller/bool-editing-controller.dart';

void main() {
  final _keyForm = GlobalKey<FormState>();

  final controller = BoolEditingController();

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
