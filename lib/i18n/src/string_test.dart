// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'string.dart';
import 'i18n.dart';

void main() {
  group('[i18n.datetime]', () {
    test('should parse string to date', () async {
      await setPreferLocale(const Locale('en', 'US'));
      final date = 'January 2, 2021'.parseDate;
      expect(date.year, 2021);
      expect(date.month, 1);
      expect(date.day, 2);

      await setPreferLocale(const Locale('zh', 'CN'));
      final date2 = '2021年1月2日'.parseDate;
      expect(date2.year, 2021);
      expect(date2.month, 1);
      expect(date2.day, 2);
    });

    test('should parse string to time', () async {
      await setPreferLocale(const Locale('en', 'US'));
      final date = '10:23 PM'.parseTime;
      expect(date.hour, 22);
      expect(date.minute, 23);

      await setPreferLocale(const Locale('zh', 'CN'));
      final date2 = '22:23'.parseTime;
      expect(date2.hour, 22);
      expect(date2.minute, 23);
    });

    test('should parse string to date time', () async {
      await setPreferLocale(const Locale('en', 'US'));
      final date = 'January 2, 2021 11:30 PM'.parseDateTime;
      expect(date.year, 2021);
      expect(date.month, 1);
      expect(date.day, 2);
      expect(date.hour, 23);
      expect(date.minute, 30);

      await setPreferLocale(const Locale('zh', 'CN'));
      final date2 = '2021年1月2日 23:30'.parseDateTime;
      expect(date2.year, 2021);
      expect(date2.month, 1);
      expect(date2.day, 2);
      expect(date.hour, 23);
      expect(date.minute, 30);
    });
  });
}
