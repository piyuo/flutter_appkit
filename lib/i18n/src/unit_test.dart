// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'i18n.dart';
import 'unit.dart';

void main() {
  setUp(() async {});

  group('[i18n.unit]', () {
    test('should get miles', () async {
      await setPreferLocale(const Locale('en', 'US'));
      expect(metersToKmOrMiles(100), '0.06 miles');
    });

    test('should get km', () async {
      await setPreferLocale(const Locale('zh', 'TW'));
      expect(metersToKmOrMiles(100), '0.10 km');
    });
  });
}
