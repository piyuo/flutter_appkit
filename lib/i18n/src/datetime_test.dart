import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'datetime.dart';
import 'i18n.dart';

void main() {
  setUp(() async {});

  group('[i18n]', () {
    test('should get date format', () async {
      await changeDateFormatting('en_US');
      var df = dateFormat;
      expect(df, isNotNull);
      expect(datePattern, 'MMMM d, y');

      await changeDateFormatting('zh_TW');
      expect(datePattern, 'y年M月d日');
    });

    test('should get time format', () async {
      await changeDateFormatting('en_US');
      var tf = timeFormat;
      expect(tf, isNotNull);
      expect(timePattern, 'h:mm a');

      await changeDateFormatting('zh_TW');
      expect(timePattern, 'ah:mm');
    });

    test('should get date time format', () async {
      await changeDateFormatting('en_US');
      var dtf = dateTimeFormat;
      expect(dtf, isNotNull);
      expect(dateTimePattern, 'MMMM d, y h:mm a');

      await changeDateFormatting('zh_TW');
      expect(dateTimePattern, 'y年M月d日 ah:mm');
    });

    test('should init date formatting', () async {
      var date = DateTime.utc(1989, 11, 9, 23, 30);

      await changeDateFormatting('en_US');
      String str = DateFormat.yMMMd().format(date);
      expect(str, 'Nov 9, 1989');
      str = DateFormat.jm('en_US').format(date);
      expect(str, '11:30 PM');

      await changeDateFormatting('zh_TW');
      var str2 = DateFormat.jm('zh_TW').format(date);
      expect(str2, '下午11:30');
    });

    test('should with locale', () async {
      await changeDateFormatting('en_US');
      var date = DateTime.utc(1989, 11, 9, 23, 30);
      withLocale('en_US', () {
        var str3 = DateFormat.jm().format(date);
        expect(str3, '11:30 PM');
      });

      await changeDateFormatting('zh_TW');
      withLocale('zh_TW', () {
        var str3 = DateFormat.jm().format(date);
        expect(str3, '下午11:30');
      });
    });

    test('should convert fixed time to string', () async {
      await changeDateFormatting('en_US');
      var str = formatTimeFixed(07, 30);
      expect(str, '7:30 AM');
      str = formatTimeFixed(12, 0);
      expect(str, '12:00 PM');
      str = formatTimeFixed(0, 0);
      expect(str, '12:00 AM');

      await changeDateFormatting('zh_TW');
      str = formatTimeFixed(07, 30);
      expect(str, '上午7:30');
      str = formatTimeFixed(12, 00);
      expect(str, '下午12:00');
    });

    test('should not have error when convert fixed time to string', () async {
      await changeDateFormatting('en_US');
      var str = formatTimeFixed(25, 67);
      expect(str, '2:07 AM');
    });

    test('should convert date to string', () async {
      await changeDateFormatting('en_US');
      var date = DateTime.utc(2021, 1, 2, 23, 30);
      var str = formatDate(date);
      expect(str, 'January 2, 2021');

      await changeDateFormatting('zh_CN');
      str = formatDate(date);
      expect(str, '2021年1月2日');
    });

    test('should parse string to date', () async {
      await changeDateFormatting('en_US');
      final date = parseDate('January 2, 2021');
      expect(date.year, 2021);
      expect(date.month, 1);
      expect(date.day, 2);

      await changeDateFormatting('zh_CN');
      final date2 = parseDate('2021年1月2日');
      expect(date2.year, 2021);
      expect(date2.month, 1);
      expect(date2.day, 2);
    });

    test('should convert time to string', () async {
      await changeDateFormatting('en_US');
      var date = DateTime.utc(2021, 1, 2, 23, 30);
      var str = formatTime(date);
      expect(str, '11:30 PM');

      await changeDateFormatting('zh_CN');
      str = formatTime(date);
      expect(str, '下午11:30');
    });

    test('should convert date time to string', () async {
      await changeDateFormatting('en_US');
      var date = DateTime.utc(2021, 1, 2, 23, 30);
      var str = formatDateTime(date);
      expect(str, 'January 2, 2021 11:30 PM');

      await changeDateFormatting('zh_CN');
      str = formatDateTime(date);
      expect(str, '2021年1月2日 下午11:30');
    });
  });
}
