import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:libcli/src/i18n/time.dart';
import 'package:libcli/src/i18n/i18n.dart';

void main() {
  setUp(() async {});

  group('[i18n]', () {
    test('should init date formatting', () async {
      var date = DateTime.utc(1989, 11, 9, 23, 30);

      await initializeDateFormatting('en_US', null);
      String str = DateFormat.yMMMd().format(date);
      expect(str, 'Nov 9, 1989');
      str = DateFormat.jm('en_US').format(date);
      expect(str, '11:30 PM');

      await initializeDateFormatting('zh_TW', null);
      var str2 = DateFormat.jm('zh_TW').format(date);
      expect(str2, '下午11:30');
    });

    test('should with locale', () async {
      await initializeDateFormatting('en_US', null);
      var date = DateTime.utc(1989, 11, 9, 23, 30);
      setLocale('en_US');
      withLocale(() {
        var str3 = DateFormat.jm().format(date);
        expect(str3, '11:30 PM');
      });

      await initializeDateFormatting('zh_TW', null);
      setLocale('zh_TW');
      withLocale(() {
        var str3 = DateFormat.jm().format(date);
        expect(str3, '下午11:30');
      });
    });

    test('should convert fixed time to string', () async {
      await initializeDateFormatting('en_US', null);
      setLocale('en_US');
      var str = fixedTimeToStr(07, 30);
      expect(str, '7:30 AM');
      str = fixedTimeToStr(12, 0);
      expect(str, '12:00 PM');
      str = fixedTimeToStr(0, 0);
      expect(str, '12:00 AM');

      await initializeDateFormatting('zh_TW', null);
      setLocale('zh_TW');
      str = fixedTimeToStr(07, 30);
      expect(str, '上午7:30');
      str = fixedTimeToStr(12, 00);
      expect(str, '下午12:00');
    });

    test('should not have error when convert fixed time to string', () async {
      await initializeDateFormatting('en_US', null);
      setLocale('en_US');
      var str = fixedTimeToStr(25, 67);
      expect(str, '2:07 AM');
    });

    test('should convert date to string', () async {
      await initializeDateFormatting('en_US', null);
      setLocale('en_US');
      var date = DateTime.utc(2021, 1, 2, 23, 30);
      var str = dateToStr(date);
      expect(str, 'Jan 2, 2021');

      setLocale('zh_CN');
      str = dateToStr(date);
      expect(str, '2021年1月2日');
    });

    test('should convert time to string', () async {
      await initializeDateFormatting('en_US', null);
      setLocale('en_US');
      var date = DateTime.utc(2021, 1, 2, 23, 30);
      var str = timeToStr(date);
      expect(str, '11:30 PM');

      setLocale('zh_CN');
      str = timeToStr(date);
      expect(str, '下午11:30');
    });

    test('should convert date time to string', () async {
      await initializeDateFormatting('en_US', null);
      setLocale('en_US');
      var date = DateTime.utc(2021, 1, 2, 23, 30);
      var str = datetimeToStr(date);
      expect(str, 'Jan 2, 2021 11:30 PM');

      setLocale('zh_CN');
      str = datetimeToStr(date);
      expect(str, '2021年1月2日 下午11:30');
    });
  });
}
