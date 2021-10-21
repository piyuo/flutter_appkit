import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing.dart' as testing;
import 'back_button.dart';

void main() {
  group('[page_route]', () {
    test('should return back button', () {
      expect(backButton(testing.Context()), isNull);
    });
  });
}
