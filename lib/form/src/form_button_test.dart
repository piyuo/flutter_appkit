// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'form_button.dart';

void main() {
  setUp(() {});

  group('[form_button]', () {
    testWidgets('should click', (WidgetTester tester) async {
      bool clicked = false;

      await testing.mockApp(tester,
          child: FormButton(
            label: 'button',
            onPressed: () async {
              clicked = true;
            },
          ));
      await tester.tap(find.byType(FormButton));
      await tester.pumpAndSettle(const Duration(seconds: 2)); // need wait done toast
      expect(clicked, true); // second item value
    });
  });
}
