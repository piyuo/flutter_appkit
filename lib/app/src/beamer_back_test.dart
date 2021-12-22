// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'beamer_back.dart';

void main() {
  group('[app.back_button]', () {
    test('should return back button', () {
      expect(beamerBack(testing.Context()), isNull);
    });
  });
}
