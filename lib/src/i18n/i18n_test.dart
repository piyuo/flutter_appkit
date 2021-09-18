import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/src/i18n/i18n.dart';

void main() {
  setUp(() async {});

  group('[i18n]', () {
    test('should set/get locale', () async {
      setLocale('zh_CN');
      expect(localeName, 'zh_CN');
      setLocale('en_US');
      expect(localeName, 'en_US');
    });

    test('should convert locale to string', () async {
      final str = const Locale('en', 'US').toString();
      expect('en_US', str);
      final l = stringToLocale(str);
      expect(l.languageCode, 'en');
      expect(l.countryCode, 'US');
    });

    test('should convert locale to http accept language header', () async {
      final l = localeToAcceptLanguage(const Locale('en', 'US'));
      expect(l, 'en-US');
    });
/*
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
    });*/
  });
}
