// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'datetime.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'i18n.dart';

void main() {
  group('[i18n.datetime]', () {
    test('should check is same day', () async {
      expect(DateTime(2023, 1, 18).isSameDay(DateTime(2023, 1, 18)), isTrue);
      expect(DateTime(2023, 1, 18).isSameDay(DateTime(2023, 1, 18, 01, 01)), isTrue);
      expect(DateTime(2023, 1, 18).isSameDay(DateTime(2023, 1, 19)), isFalse);
    });

    test('should return date only', () async {
      expect(DateTime(2023, 1, 18, 23, 11).dateOnly, DateTime(2023, 1, 18));
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
      await setPreferLocale(const Locale('en', 'US'));
      var df = dateFormat;
      expect(df, isNotNull);
      expect(datePattern, 'MMMM d, y');

      await setPreferLocale(const Locale('zh', 'TW'));
      expect(datePattern, 'y年M月d日');
    });

    test('should get time format', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var tf = timeFormat;
      expect(tf, isNotNull);
      expect(timePattern, 'h:mm a');

      await setPreferLocale(const Locale('zh', 'TW'));
      expect(timePattern, 'ah:mm');
    });

    test('should get date time format', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var dtf = dateTimeFormat;
      expect(dtf, isNotNull);
      expect(dateTimePattern, 'MMMM d, y h:mm a');

      await setPreferLocale(const Locale('zh', 'TW'));
      expect(dateTimePattern, 'y年M月d日 ah:mm');
    });

    test('should init date formatting', () async {
      var date = DateTime(1989, 11, 9, 23, 30);

      await setPreferLocale(const Locale('en', 'US'));
      String str = DateFormat.yMMMd().format(date);
      expect(str, 'Nov 9, 1989');
      str = DateFormat.jm('en_US').format(date);
      expect(str, '11:30 PM');

      await setPreferLocale(const Locale('zh', 'TW'));
      var str2 = DateFormat.jm('zh_TW').format(date);
      expect(str2, '下午11:30');
    });

    test('should with locale', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(1989, 11, 9, 23, 30);
      withLocale('en_US', () {
        var str3 = DateFormat.jm().format(date);
        expect(str3, '11:30 PM');
      });

      await setPreferLocale(const Locale('zh', 'TW'));
      withLocale('zh_TW', () {
        var str3 = DateFormat.jm().format(date);
        expect(str3, '下午11:30');
      });
    });

    test('should convert fixed time to string', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var str = formatTimeFixed(07, 30);
      expect(str, '7:30 AM');
      str = formatTimeFixed(12, 0);
      expect(str, '12:00 PM');
      str = formatTimeFixed(0, 0);
      expect(str, '12:00 AM');

      await setPreferLocale(const Locale('zh', 'TW'));
      str = formatTimeFixed(07, 30);
      expect(str, '上午7:30');
      str = formatTimeFixed(12, 00);
      expect(str, '下午12:00');
    });

    test('should not have error when convert fixed time to string', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var str = formatTimeFixed(25, 67);
      expect(str, '2:07 AM');
    });

    test('should return formatted month and day string', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2021, 1, 2, 23, 30);
      expect(date.formattedDate, 'January 2, 2021');
      expect(date.formattedMonthDay, 'Jan 2');
      expect(date.formattedMonth, 'January');
      expect(date.formattedMonthShort, 'Jan');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedMonthDay, '1月2日');
      expect(date.formattedDate, '2021年1月2日');
      expect(date.formattedMonth, '一月');
      expect(date.formattedMonthShort, '1月');
    });

    test('formatMonth should convert date to month string', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2021, 1, 2, 23, 30);
      expect(date.formattedMonthShort, 'Jan');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedMonthShort, '1月');
    });

    test('formatDay should convert date to day string', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2021, 1, 2, 23, 30);
      expect(date.formattedDay, '2');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedDay, '2日');
    });

    test('formatMonthDay should convert date to month and day string', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2021, 1, 2, 23, 30);
      expect(date.formattedMonthDay, 'Jan 2');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedMonthDay, '1月2日');
    });

    test('formatYear should convert date to year', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2021, 1, 2, 23, 30);
      expect(date.formattedYear, '2021');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedYear, '2021年');
    });

    test('should convert time to string', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2021, 1, 2, 23, 30);
      expect(date.formattedTime, '11:30 PM');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedTime, '23:30');
    });

    test('should convert date time to string', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2021, 1, 2, 23, 30);
      expect(date.formattedDateTime, 'January 2, 2021 11:30 PM');

      await setPreferLocale(const Locale('zh', 'TW'));
      expect(date.formattedDateTime, '2021年1月2日 下午11:30');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedDateTime, '2021年1月2日 23:30');
    });

    test('should return formatted weekday', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2023, 1, 16);
      expect(date.formattedWeekday, 'Monday');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedWeekday, '星期一');
    });

    test('should formatted weekday in short', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2023, 1, 16);
      expect(date.formattedWeekdayShort, 'Mon');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedWeekdayShort, '周一');
    });

    test('should formatted weekday short month day', () async {
      await setPreferLocale(const Locale('en', 'US'));
      expect(DateTime(2023, 1, 16).formattedWeekdayShortMonthDay, 'Mon, Jan 16');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(DateTime(2023, 1, 16).formattedWeekdayShortMonthDay, '周一, 1月16日');
    });

    test('should formatted weekday short month day time', () async {
      await setPreferLocale(const Locale('en', 'US'));
      expect(DateTime(2023, 1, 16, 17, 23).formattedWeekdayShortMonthDayTime, 'Mon, Jan 16, 5:23 PM');

      await setPreferLocale(const Locale('zh', 'CN'));
      expect(DateTime(2023, 1, 16, 17, 23).formattedWeekdayShortMonthDayTime, '周一, 1月16日, 17:23');
    });

    test('should return pretty weekday', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var now = DateTime.now();
      expect(now.formattedWeekdayAware(testing.context), 'Today');
      expect(now.add(const Duration(days: 1)).formattedWeekdayAware(testing.context), 'Tomorrow');
      expect(now.add(const Duration(days: -1)).formattedWeekdayAware(testing.context), 'Yesterday');
      expect(now.add(const Duration(days: 2)).formattedWeekdayAware(testing.context), isNotEmpty);
    });

    test('should return pretty weekday short', () async {
      await setPreferLocale(const Locale('en', 'US'));
      var now = DateTime.now();
      expect(now.formattedWeekdayAware(testing.context), 'Today');
      expect(now.add(const Duration(days: 1)).formattedWeekdayAwareShort(testing.context), 'Tomorrow');
      expect(now.add(const Duration(days: -1)).formattedWeekdayAwareShort(testing.context), 'Yesterday');
      expect(now.add(const Duration(days: 2)).formattedWeekdayAwareShort(testing.context), isNotEmpty);
    });

    test('should return true if date is in date list', () async {
      final dates = [DateTime(2021, 1, 1), DateTime(2021, 1, 2), DateTime(2021, 1, 3)];
      expect(dates.contains(DateTime(2021, 1, 1)), isTrue);
      expect(dates.contains(DateTime(2021, 1, 5)), isFalse);
    });
  });
}
