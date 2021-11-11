import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dropdown_field.dart';

void main() {
  final _keyForm = GlobalKey<FormState>();

  final controller = ValueNotifier<dynamic>('');

  setUp(() {});

  Widget testTarget() {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _keyForm,
          child: DropdownField<dynamic>(
            key: const Key('test-dropdown'),
            controller: controller,
            items: const {
              "": "item0",
              "1": "item1",
            },
          ),
        ),
      ),
    );
  }

  group('[dropdown]', () {
    testWidgets('should pass value to controller', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());
      expect(controller.value, ''); // first item value
      expect(find.text('item1'), findsOneWidget); // one in FromDropdown items
      await tester.tap(find.byType(DropdownField));
      await tester.pumpAndSettle();
      expect(find.text('item1'), findsWidgets); // one in items, one in popup menu
      await tester.tap(find.text('item1').last);
      await tester.pumpAndSettle();
      expect(controller.value, '1'); // second item value
    });
  });
}
