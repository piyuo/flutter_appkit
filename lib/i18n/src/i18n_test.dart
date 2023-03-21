// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'i18n.dart';
import 'package:flutter/material.dart';
import 'package:libcli/assets/assets.dart' as asset;
import 'package:intl/date_symbol_data_local.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/preferences/preferences.dart' as storage;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  storage.initForTest({});
  setUp(() async {
    asset.mock('{"a": "A"}');
  });

  tearDown(() async {
    asset.mockDone();
  });

  group('[i18n]', () {
    test('should get default locale en', () async {
      expect(localeKey, 'en');
    });

    test('should get local date', () async {
      var date = DateTime.utc(2021, 1, 2, 23, 30);
      var localDate = date.toLocal();
      google.Timestamp t = google.Timestamp.fromDateTime(date);
      expect(localDate, t.local);
    });

    test('should set local date', () async {
      var d = DateTime(2021, 1, 2, 23, 30);
      var t = timestamp();
      t.local = d;
      expect(t.local, d);
    });

    test('should create utc TimeStamp', () async {
      var date = DateTime(2021, 1, 2, 23, 30);
      google.Timestamp t = timestamp(datetime: date);
      expect(date, t.local);
    });

    test('should convert to local string', () async {
      await initializeDateFormatting('en_US', null);
      var date = DateTime(2021, 1, 2, 23, 30);
      google.Timestamp t = timestamp(datetime: date);

      mockLocale('en_US');
      expect(t.localDateString, 'January 2, 2021');
      expect(t.localTimeString, '11:30 PM');
      expect(t.localDateTimeString, 'January 2, 2021 11:30 PM');

      mockLocale('zh_CN');
      expect(t.localDateString, '2021年1月2日');
      expect(t.localTimeString, '23:30');
      expect(t.localDateTimeString, '2021年1月2日 23:30');
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
      final l = stringToLocale(str);
      expect(l.languageCode, 'en');
      expect(l.countryCode, 'US');
    });

/*
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
    });*/
  });
}

class L10nWidget extends StatelessWidget {
  static String value = '';

  const L10nWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    value = context.i18n.okButtonText;
    return Text(value);
  }
}
