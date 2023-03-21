// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'i18n.dart';
import 'unit.dart';

void main() {
  setUp(() async {});

  group('[i18n.unit]', () {
    test('should get miles', () async {
      mockLocale('en_US');
      expect(metersToKmOrMiles(100), '0.06 miles');
    });

    test('should get km', () async {
      mockLocale('zh_TW');
      expect(metersToKmOrMiles(100), '0.10 km');
    });
  });
}
