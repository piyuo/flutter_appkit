// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import 'is_test_mode.dart';

void main() {
  group('[testing.is_test_mode]', () {
    test('should return true', () async {
      expect(isTestMode, true);
    });
  });
}
