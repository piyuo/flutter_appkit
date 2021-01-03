import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/i18n.dart';
import 'package:flutter/widgets.dart';

void main() {
  setUp(() async {});

  group('[i18n]', () {
    test('should set/get global variable', () async {
      locale = Locale('en', 'US');
      expect(currentLocaleID, 'en_US');
    });

    test('should convert locale to id', () async {
      expect(localeToId(Locale('en', 'US')), 'en_US');
    });

    test('should determine locale', () async {
      List<Locale> emptyList = [];
      Locale loc = determineLocale(emptyList);
      expect(localeToId(loc), 'en_US');
      expect(userPreferCountryCode, 'US');

      List<Locale> list = [Locale('zh', 'TW'), Locale('en', 'CA')];
      loc = determineLocale(list);
      expect(localeToId(loc), 'zh_TW');
      expect(userPreferCountryCode, 'TW');
    });
  });
}
