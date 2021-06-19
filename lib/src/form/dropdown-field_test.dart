import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dropdown-field.dart';

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
          child: Column(
            children: [
              DropdownField(
                controller: controller,
                items: {
                  "": "item0",
                  "1": "item1",
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('[dropdown]', () {
    testWidgets('should pass value to controller', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      expect(controller.text, ''); // first item value
      expect(find.text('item1'), findsOneWidget); // one in FromDropdown items
      await tester.tap(find.byType(DropdownField));
      await tester.pumpAndSettle();
      expect(find.text('item1'), findsWidgets); // one in items, one in popup menu
      await tester.tap(find.text('item1').last);
      await tester.pumpAndSettle();
      expect(controller.text, '1'); // second item value
    });
  });
}
