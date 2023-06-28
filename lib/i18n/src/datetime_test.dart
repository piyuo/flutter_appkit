// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'datetime.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/testing/testing.dart' as testing;
import 'i18n.dart';

void main() {
  group('[i18n.datetime]', () {
    test('should check is same day', () async {
      expect(DateTime(2023, 1, 18).isSameDay(DateTime(2023, 1, 18)), isTrue);
      expect(DateTime(2023, 1, 18).isSameDay(DateTime(2023, 1, 18, 01, 01)), isTrue);
      expect(DateTime(2023, 1, 18).isSameDay(DateTime(2023, 1, 19)), isFalse);
    });

    test('should check min and max value', () async {
      var now = DateTime.now();
      expect(now.isMax, isFalse);
      expect(now.isMin, isFalse);
      expect(minDateTime.isMin, isTrue);
      expect(minDateTime.isMax, isFalse);
      expect(maxDateTime.isMin, isFalse);
      expect(maxDateTime.isMax, isTrue);
    });

    test('should check yesterday/today/tomorrow', () async {
      var now = DateTime.now();
      expect(now.isToday, isTrue);
      now = DateTime.now().add(const Duration(days: 1));
      expect(now.isTomorrow, isTrue);
      now = DateTime.now().add(const Duration(days: -1));
      expect(now.isYesterday, isTrue);
    });

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
      var date = DateTime(1989, 11, 9, 23, 30);

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
      var date = DateTime(1989, 11, 9, 23, 30);
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
      var date = DateTime(2021, 1, 2, 23, 30);
      var str = formatDate(date);
      expect(str, 'January 2, 2021');
      expect(getMonthName(date), 'January');
      expect(getMonthNameShort(date), 'Jan');
      expect(date.monthName, 'January');
      expect(date.monthNameShort, 'Jan');

      await changeDateFormatting('zh_CN');
      str = formatDate(date);
      expect(str, '2021年1月2日');
      expect(getMonthName(date), '一月');
      expect(getMonthNameShort(date), '1月');
      expect(date.monthName, '一月');
      expect(date.monthNameShort, '1月');
    });

    test('formatMonthDay should convert date to month and day string', () async {
      await changeDateFormatting('en_US');
      var date = DateTime(2021, 1, 2, 23, 30);
      expect(formatMonthDay(date), 'Jan 2');

      await changeDateFormatting('zh_CN');
      expect(formatMonthDay(date), '1月2日');
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
      var date = DateTime(2021, 1, 2, 23, 30);
      var str = formatTime(date);
      expect(str, '11:30 PM');

      await changeDateFormatting('zh_CN');
      str = formatTime(date);
      expect(str, '23:30');
    });

    test('should parse string to time', () async {
      await changeDateFormatting('en_US');
      final date = parseTime('10:23 PM');
      expect(date.hour, 22);
      expect(date.minute, 23);

      await changeDateFormatting('zh_CN');
      final date2 = parseTime('22:23');
      expect(date2.hour, 22);
      expect(date2.minute, 23);
    });

    test('should convert date time to string', () async {
      await changeDateFormatting('en_US');
      var date = DateTime(2021, 1, 2, 23, 30);
      var str = formatDateTime(date);
      expect(str, 'January 2, 2021 11:30 PM');

      await changeDateFormatting('zh_TW');
      str = formatDateTime(date);
      expect(str, '2021年1月2日 下午11:30');

      await changeDateFormatting('zh_CN');
      str = formatDateTime(date);
      expect(str, '2021年1月2日 23:30');
    });

    test('should parse string to date time', () async {
      await changeDateFormatting('en_US');
      final date = parseDateTime('January 2, 2021 11:30 PM');
      expect(date.year, 2021);
      expect(date.month, 1);
      expect(date.day, 2);
      expect(date.hour, 23);
      expect(date.minute, 30);

      await changeDateFormatting('zh_CN');
      final date2 = parseDateTime('2021年1月2日 23:30');
      expect(date2.year, 2021);
      expect(date2.month, 1);
      expect(date2.day, 2);
      expect(date.hour, 23);
      expect(date.minute, 30);
    });

    test('should format timestamp', () async {
      await changeDateFormatting('en_US');
      final stamp = google.Timestamp.fromDateTime(DateTime(2021, 1, 2, 23, 30).toUtc());
      var str = formatDateStamp(stamp);
      expect(str, 'January 2, 2021');
      str = formatDateTimeStamp(stamp);
      expect(str, 'January 2, 2021 11:30 PM');
      str = formatTimeStamp(stamp);
      expect(str, '11:30 PM');

      await changeDateFormatting('zh_CN');
      str = formatDateStamp(stamp);
      expect(str, '2021年1月2日');
      str = formatDateTimeStamp(stamp);
      expect(str, '2021年1月2日 23:30');
      str = formatTimeStamp(stamp);
      expect(str, '23:30');
    });

    test('should format duration', () async {
      await changeDateFormatting('en_US');
      const dur = Duration(
        days: 5,
        hours: 23,
        minutes: 59,
        seconds: 59,
        milliseconds: 999,
        microseconds: 999,
      );
      const min12sec35 = Duration(
        minutes: 12,
        seconds: 35,
      );
      expect(formatDuration(dur), '5 days 23 hours 59 minutes 59 seconds');
      expect(formatDuration(min12sec35), '12 minutes 35 seconds');

      await changeDateFormatting('zh_CN');
      expect(formatDuration(dur), '5日 23小时 59分 59秒');
      expect(formatDuration(min12sec35), '12分 35秒');

      await changeDateFormatting('zh_TW');
      expect(formatDuration(dur), '5日 23小時 59分鐘 59秒');
      expect(formatDuration(min12sec35), '12分鐘 35秒');
    });

    test('should format weekday', () async {
      await changeDateFormatting('en_US');
      var date = DateTime(2023, 1, 16);
      var str = formatWeekday(date);
      expect(str, 'Monday');
      expect(date.weekdayName, 'Monday');

      await changeDateFormatting('zh_CN');
      str = formatWeekday(date);
      expect(str, '星期一');
      expect(date.weekdayName, '星期一');
    });

    test('should format weekday in short', () async {
      await changeDateFormatting('en_US');
      var date = DateTime(2023, 1, 16);
      var str = formatWeekdayShort(date);
      expect(str, 'Mon');
      expect(date.weekdayNameShort, 'Mon');

      await changeDateFormatting('zh_CN');
      str = formatWeekdayShort(date);
      expect(str, '周一');
      expect(date.weekdayNameShort, '周一');
    });

    test('should return pretty weekday', () async {
      await changeDateFormatting('en_US');
      var now = DateTime.now();
      expect(now.prettyWeekdayName(testing.context), 'Today');
      expect(formatPrettyWeekday(testing.context, now), 'Today');
      expect(formatPrettyWeekday(testing.context, now.add(const Duration(days: 1))), 'Tomorrow');
      expect(formatPrettyWeekday(testing.context, now.add(const Duration(days: -1))), 'Yesterday');
      expect(formatPrettyWeekday(testing.context, now.add(const Duration(days: 2))), isNotEmpty);
    });

    test('should return pretty weekday short', () async {
      await changeDateFormatting('en_US');
      var now = DateTime.now();
      expect(now.prettyWeekdayNameShort(testing.context), 'Today');
      expect(formatPrettyWeekdayShort(testing.context, now), 'Today');
      expect(formatPrettyWeekdayShort(testing.context, now.add(const Duration(days: 1))), 'Tomorrow');
      expect(formatPrettyWeekdayShort(testing.context, now.add(const Duration(days: -1))), 'Yesterday');
      expect(formatPrettyWeekdayShort(testing.context, now.add(const Duration(days: 2))), isNotEmpty);
    });

    test('formatDateWeekday should text contain date and weekday', () async {
      await changeDateFormatting('en_US');
      var now = DateTime(2023, 06, 28);
      expect(formatDateWeekday(testing.context, now), 'Jun 28 Today');
    });
  });
}
