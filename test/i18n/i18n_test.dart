import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:flutter/material.dart';

void main() {
  setUp(() async {});

  group('[i18n]', () {
    test('should set/get global variable', () async {
      i18n.locale = Locale('en', 'US');
      expect(i18n.localeID, 'en_US');
    });
  });
}
