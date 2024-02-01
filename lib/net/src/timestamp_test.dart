// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/testing/testing.dart' as testing;

import 'timestamp.dart';

void main() {
  group('[net.timestamp]', () {
    test('should get local date', () async {
      var date = DateTime(2021, 1, 2, 23, 30);
      google.Timestamp t = date.toUtc().timestamp;
      expect(t.localDateTime, date);
    });

    test('should convert to Iso8601 string', () async {
      final t = DateTime(2021, 1, 2, 23, 30).timestamp;
      final str = t.toIso8601String();
      final t2 = fromIso8601String(str);
      expect(t2.localDateTime, DateTime(2021, 1, 2, 23, 30));
    });

    test('should set local date', () async {
      var d = DateTime(2021, 1, 2, 23, 30);
      var t = d.timestamp;
      expect(t.localDateTime, d);
    });

    test('should return date only', () async {
      expect(DateTime(2023, 1, 18, 23, 11).timestamp.dateOnly, DateTime(2023, 1, 18).timestamp);
    });

    test('should format timestamp', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      final stamp = DateTime(2021, 1, 2, 23, 30).timestamp;
      expect(stamp.formattedDate, 'January 2, 2021');
      expect(stamp.formattedDateTime, 'January 2, 2021 11:30 PM');
      expect(stamp.formattedTime, '11:30 PM');

      await i18n.setPreferLocale(const Locale('zh', 'CN'));
      expect(stamp.formattedDate, '2021年1月2日');
      expect(stamp.formattedDateTime, '2021年1月2日 23:30');
      expect(stamp.formattedTime, '23:30');
    });

    test('should return formatted month and day string', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      var timestamp = DateTime(2021, 1, 2, 23, 30).timestamp;
      expect(timestamp.formattedDate, 'January 2, 2021');
      expect(timestamp.formattedMonthDay, 'Jan 2');
      expect(timestamp.formattedMonth, 'January');
      expect(timestamp.formattedMonthShort, 'Jan');

      await i18n.setPreferLocale(const Locale('zh', 'CN'));
      expect(timestamp.formattedMonthDay, '1月2日');
      expect(timestamp.formattedDate, '2021年1月2日');
      expect(timestamp.formattedMonth, '一月');
      expect(timestamp.formattedMonthShort, '1月');
    });

    test('should return formatted weekday', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      var timestamp = DateTime(2023, 1, 16).timestamp;
      expect(timestamp.formattedWeekday, 'Monday');

      await i18n.setPreferLocale(const Locale('zh', 'CN'));
      expect(timestamp.formattedWeekday, '星期一');
    });

    test('should formatted weekday in short', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      var timestamp = DateTime(2023, 1, 16).timestamp;
      expect(timestamp.formattedWeekdayShort, 'Mon');

      await i18n.setPreferLocale(const Locale('zh', 'CN'));
      expect(timestamp.formattedWeekdayShort, '周一');
    });

    test('should return pretty weekday', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      var now = DateTime.now().timestamp;
      expect(now.formattedWeekdayAware(testing.context), 'Today');
      expect(now.add(const Duration(days: 1)).formattedWeekdayAware(testing.context), 'Tomorrow');
      expect(now.add(const Duration(days: -1)).formattedWeekdayAware(testing.context), 'Yesterday');
      expect(now.add(const Duration(days: 2)).formattedWeekdayAware(testing.context), isNotEmpty);
    });

    test('should return pretty weekday short', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      var now = DateTime.now().timestamp;
      expect(now.formattedWeekdayAware(testing.context), 'Today');
      expect(now.add(const Duration(days: 1)).formattedWeekdayAwareShort(testing.context), 'Tomorrow');
      expect(now.add(const Duration(days: -1)).formattedWeekdayAwareShort(testing.context), 'Yesterday');
      expect(now.add(const Duration(days: 2)).formattedWeekdayAwareShort(testing.context), isNotEmpty);
    });

    test('formatDay should convert date to day string', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2021, 1, 2, 23, 30).timestamp;
      expect(date.formattedDay, '2');

      await i18n.setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedDay, '2日');
    });

    test('formatMonthDay should convert date to month and day string', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2021, 1, 2, 23, 30).timestamp;
      expect(date.formattedMonthDay, 'Jan 2');

      await i18n.setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedMonthDay, '1月2日');
    });

    test('formatYear should convert date to year', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      var date = DateTime(2021, 1, 2, 23, 30).timestamp;
      expect(date.formattedYear, '2021');

      await i18n.setPreferLocale(const Locale('zh', 'CN'));
      expect(date.formattedYear, '2021年');
    });

    test('isAfter should return true when date is after other stamp', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      expect(DateTime(2021, 1, 2, 23, 31).timestamp.isAfter(DateTime(2021, 1, 2, 23, 30).timestamp), isTrue);
    });

    test('isBefore should return true when date is before other stamp', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      expect(DateTime(2021, 1, 2, 23, 29).timestamp.isBefore(DateTime(2021, 1, 2, 23, 30).timestamp), isTrue);
    });

    test('isAtSameMomentAs should return true when date is after to other stamp', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      expect(DateTime(2021, 1, 2, 23, 30).timestamp.isAtSameMomentAs(DateTime(2021, 1, 2, 23, 30).timestamp), isTrue);
    });

    test('isSameDay should return true when date is same day to other stamp', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      expect(DateTime(2021, 1, 2, 11, 30).timestamp.isSameDay(DateTime(2021, 1, 2, 22, 30).timestamp), isTrue);
    });

    test('should formatted weekday short month day', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      expect(DateTime(2023, 1, 16).timestamp.formattedWeekdayShortMonthDay, 'Mon, Jan 16');
    });

    test('should formatted weekday short month day time', () async {
      await i18n.setPreferLocale(const Locale('en', 'US'));
      expect(DateTime(2023, 1, 16, 17, 23).timestamp.formattedWeekdayShortMonthDayTime, 'Mon, Jan 16, 5:23 PM');
    });

    test('should return true if timestamp is in timestamp list', () async {
      final dates = [DateTime(2021, 1, 1).timestamp, DateTime(2021, 1, 2).timestamp, DateTime(2021, 1, 3).timestamp];
      expect(dates.contains(DateTime(2021, 1, 1).timestamp), isTrue);
      expect(dates.contains(DateTime(2021, 1, 5).timestamp), isFalse);
    });

    test('utcDate should return current date as utc', () async {
      final date1 = DateTime(2021, 1, 1);
      final timestamp = date1.timestamp;
      final date2 = timestamp.localDateTime;
      expect(date1.isUtc, isFalse);
      expect(date2.isUtc, isFalse);
      expect(date1, date2);

      expect(DateTime(2021, 1, 1).isUtc, isFalse);
      expect(google.Timestamp.fromDateTime(DateTime(2021, 1, 1)).toDateTime().isUtc, isTrue);

      final stamp = DateTime.utc(2021, 1, 1).timestamp;
      final date = stamp.toDateTime();
      final to = stamp.toDateTime();
      expect(date.year, to.year);
      expect(date.month, to.month);
      expect(date.day, to.day);
    });
    test('should create fixed date timestamp', () async {
      var date = DateTime(2021, 1, 2);
      var t = date.fixedTimestamp;
      expect(t.toDateTime(), DateTime.utc(2021, 1, 2));
      var date2 = t.fixedDate;
      expect(date, date2);
    });
  });
}
