import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/src/i18n/i18n.dart';
import 'package:libcli/testing.dart' as testing;

void main() {
  setUp(() async {});

  group('[i18n]', () {
    test('should set/get locale', () async {
      setLocale(testing.Context(), const Locale('zh', 'CN'));
      expect(localeString, 'zh_CN');
      setLocale(testing.Context(), const Locale('en', 'US'));
      expect(localeString, 'en_US');
    });

    test('should convert locale to string', () async {
      final str = localeToString(const Locale('en', 'US'));
      expect('en_US', str);
      final l = stringToLocale(str);
      expect(l.languageCode, 'en');
      expect(l.countryCode, 'US');
    });

    test('should convert locale to http accept language header', () async {
      final l = localeToAcceptLanguage(const Locale('en', 'US'));
      expect(l, 'en-US');
    });

    test('should determine locale', () async {
      List<Locale> emptyList = [];
      Locale loc = determineLocale(emptyList);
      expect(
        localeToString(loc),
        'en_US',
      );
      expect(country, 'US');

      List<Locale> list = [const Locale('zh', 'TW'), const Locale('en', 'CA')];
      loc = determineLocale(list);
      expect(localeToString(loc), 'zh_TW');
      expect(country, 'TW');
    });
  });
}
