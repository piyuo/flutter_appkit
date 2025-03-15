// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/preferences/preferences.dart' as storage;

import 'i18n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  storage.initForTest({});
  setUp(() async {});

  tearDown(() async {});

  group('[i18n]', () {
    test('should get default locale en', () async {
      expect(locale, const Locale('en'));
      await setPreferLocale(const Locale('en', 'US'));
      expect(locale, preferLocale);
    });

/*
    test('should override system locale', () async {
      var i18nProvider = I18nProvider();
      try {
        expect(i18nProvider.overrideLocale, isNull);
        await i18nProvider.overrideLocaleTemporary(const Locale('en', 'US'));
        expect(i18nProvider.overrideLocale.toString(), 'en_US');
        i18nProvider.overrideLocale = null;
        expect(i18nProvider.overrideLocale, isNull);
      } finally {
        i18nProvider.dispose();
      }
    });

    test('should set/get locale', () async {
      setLocale('zh_CN');
      expect(localeName, 'zh_CN');
      setLocale('en_US');
      expect(localeName, 'en_US');
    });
*/
    test('should convert locale to string', () async {
      final str = const Locale('en', 'US').toString();
      expect('en_US', str);
      final l = stringToLocale(str)!;
      expect(l.languageCode, 'en');
      expect(l.countryCode, 'US');
    });
  });
}

class L10nWidget extends StatelessWidget {
  static String value = '';

  const L10nWidget({super.key});

  @override
  Widget build(BuildContext context) {
    value = context.i18n.okButtonText;
    return Text(value);
  }
}
