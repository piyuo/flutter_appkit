import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/hook.dart' as vars;
import 'package:flutter/material.dart';

void main() {
  setUp(() async {});

  group('[i18n]', () {
    test('should set/get global variable', () async {
      locale = Locale('en', 'US');
      expect(localeID, 'en_US');
    });

    test('should convert locale to id', () async {
      expect(localeToId(Locale('en', 'US')), 'en_US');
    });

    test('should determine locale', () async {
      Locale loc = determineLocale(null);
      expect(localeToId(loc), 'en_US');
      expect(vars.country, 'US');

      List<Locale> emptyList = List<Locale>();
      loc = determineLocale(emptyList);
      expect(localeToId(loc), 'en_US');
      expect(vars.country, 'US');

      List<Locale> list = List<Locale>();
      list.add(Locale('zh', 'TW'));
      list.add(Locale('en', 'CA'));
      loc = determineLocale(list);
      expect(localeToId(loc), 'zh_TW');
      expect(vars.country, 'TW');
    });
  });
}
