import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/i18n.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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
      List<Locale> emptyList = [];
      Locale loc = determineLocale(emptyList);
      expect(localeToId(loc), 'en_US');
      expect(userPreferCountryCode, 'US');

      List<Locale> list = [Locale('zh', 'TW'), Locale('en', 'CA')];
      loc = determineLocale(list);
      expect(localeToId(loc), 'zh_TW');
      expect(userPreferCountryCode, 'TW');
    });

    test('should init date formatting', () async {
      var date = new DateTime.utc(1989, 11, 9, 23, 30);

      await initializeDateFormatting('en_US', null);
      String str = new DateFormat.yMMMd().format(date);
      expect(str, 'Nov 9, 1989');
      str = new DateFormat.jm('en_US').format(date);
      expect(str, '11:30 PM');

      await initializeDateFormatting('zh_TW', null);
      var str2 = new DateFormat.jm('zh_TW').format(date);
      expect(str2, '下午11:30');
    });

    test('should with locale', () async {
      await initializeDateFormatting('en_US', null);
      var date = new DateTime.utc(1989, 11, 9, 23, 30);
      locale = Locale('en', 'US');
      withLocale(() {
        var str3 = new DateFormat.jm().format(date);
        expect(str3, '11:30 PM');
      });

      await initializeDateFormatting('zh_TW', null);
      locale = Locale('zh', 'TW');
      withLocale(() {
        var str3 = new DateFormat.jm().format(date);
        expect(str3, '下午11:30');
      });
    });

    test('should convert time to string', () async {
      await initializeDateFormatting('en_US', null);
      locale = Locale('en', 'US');
      var str = timeToStr(07, 30);
      expect(str, '7:30 AM');
      str = timeToStr(12, 0);
      expect(str, '12:00 PM');
      str = timeToStr(0, 0);
      expect(str, '12:00 AM');

      await initializeDateFormatting('zh_TW', null);
      locale = Locale('zh', 'TW');
      str = timeToStr(07, 30);
      expect(str, '上午7:30');
      str = timeToStr(12, 00);
      expect(str, '下午12:00');
    });

    test('should not have error when convert time to string', () async {
      await initializeDateFormatting('en_US', null);
      locale = Locale('en', 'US');
      var str = timeToStr(25, 67);
      expect(str, '2:07 AM');
    });
  });
}
