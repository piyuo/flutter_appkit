// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'button.dart';

void main() {
  setUp(() {});

  group('[button]', () {
    testWidgets('should click', (WidgetTester tester) async {
      bool clicked = false;
      await testing.mockApp(tester,
          child: Button(
            key: const Key('Button'),
            label: 'button',
            onPressed: () async {
              clicked = true;
            },
          ));
      await tester.tap(find.byType(Button));
      await tester.pumpAndSettle();
      expect(clicked, true); // second item value
    });
  });
}
