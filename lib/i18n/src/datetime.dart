import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:libcli/google/google.dart' as google;
import 'i18n.dart';

/// minDateTime return the minimum date
DateTime get minDateTime => DateTime.utc(-271821, 04, 20);

/// maxDateTime return the maximum date
DateTime get maxDateTime => DateTime.utc(275760, 09, 13);

extension DateHelpers on DateTime {
  /// difference return the difference (in full days) between today
  int get difference {
    DateTime now = DateTime.now();
    return DateTime(year, month, day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  /// isSameDay return true if the date is same day with other day. (ignore time)
  /// ```dart
  /// expect(DateTime(2023, 1, 18).isSameDay(DateTime(2023, 1, 18)), isTrue);
  /// ```
  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  /// isToday return true if the date is today
  bool get isToday => difference == 0;

  /// isYesterday return true if the date is yester
  bool get isYesterday => difference == -1;

  /// isTomorrow return true if the date is tomorrow
  bool get isTomorrow => difference == 1;

  /// isMin return true if the date is min
  /// ```dart
  /// expect(now.isMin, isTrue);
  /// ```
  bool get isMin => compareTo(minDateTime) == 0;

  /// isMax return true if the date is max
  /// ```dart
  /// expect(now.isMax, isTrue);
  /// ```
  bool get isMax => compareTo(maxDateTime) == 0;
}

/// changeDateFormatting change locale and load date formatting resource
/// ```dart
/// await changeDateFormatting('en_US');
/// ```
Future<void> changeDateFormatting(String locale) async {
  Intl.defaultLocale = locale;
  await initializeDateFormatting(locale, null);
}

/// dateFormat return current date format
DateFormat get dateFormat {
  return DateFormat.yMMMMd(localeName);
}

/// datePattern return current date pattern
/// ```dart
/// expect(datePattern, 'MMMM d, y');
/// ```
String get datePattern {
  return dateFormat.pattern ?? '';
}

/// timeFormat return current time format
DateFormat get timeFormat {
  return DateFormat.jm(localeName);
}

/// timePattern return current time pattern
/// ```dart
/// expect(timePattern, 'h:mm a');
/// ```
String get timePattern {
  return timeFormat.pattern ?? '';
}

/// dateTimeFormat return current date time format
DateFormat get dateTimeFormat {
  return DateFormat.yMMMMd(localeName).add_jm();
}

/// dateTimePattern return current date time pattern
/// ```dart
/// expect(dateTimePattern, 'MMMM d, y h:mm a');
/// ```
String get dateTimePattern {
  return dateTimeFormat.pattern ?? '';
}

/// formatTimeFixed convert hour and minute to local string
/// ```dart
/// var str = formatTimeFixed(07, 30);
/// expect(str, '7:30 AM');
/// ```
String formatTimeFixed(int hour, int minute) {
  var date = DateTime(2001, 1, 1, hour, minute);
  return timeFormat.format(date);
}

/// formatDate convert date to local string
/// ```dart
/// var str = formatDate(date);
/// expect(str, 'Jan 2, 2021');
/// ```
String formatDate(DateTime date) => dateFormat.format(date);

/// parseDate parse string to date
/// ```dart
/// final date = parseDate('January 2, 2021');
/// expect(date.year, 2021);
/// ```
DateTime parseDate(String date) => dateFormat.parse(date);

/// formatDateTime convert date and time to local string
/// ```dart
///  var str = formatDateTime(date);
///  expect(str, 'January 2, 2021 11:30 PM');
/// ```
String formatDateTime(DateTime datetime) => dateTimeFormat.format(datetime);

/// formatTime convert time to local string
/// ```dart
/// var str = formatTime(date);
/// expect(str, '11:30 PM');
/// ```
String formatTime(DateTime time) => timeFormat.format(time);

/// formatDateStamp convert stamp to local date string
/// ```dart
/// var str = formatDateStamp(stamp);
/// expect(str, 'Jan 2, 2021');
/// ```
String formatDateStamp(google.Timestamp stamp) => formatDate(stamp.toDateTime().toLocal());

/// formatDateTimeStamp convert stamp to local date time string
/// ```dart
///  var str = formatDateTimeStamp(stamp);
///  expect(str, 'January 2, 2021 11:30 PM');
/// ```
String formatDateTimeStamp(google.Timestamp stamp) => formatDateTime(stamp.toDateTime().toLocal());

/// formatTime convert stamp to local time string
/// ```dart
/// var str = formatTimeStamp(stamp);
/// expect(str, '11:30 PM');
/// ```
String formatTimeStamp(google.Timestamp stamp) => formatTime(stamp.toDateTime().toLocal());

/// formatDuration convert duration to local string
/// ```dart
/// expect(formatDuration(dur), '5 days 23 hours 59 minutes 59 seconds');
/// ```
String formatDuration(Duration duration) {
  final l = locale;
  DurationLocale? dl;
  if (localeName == 'zh_TW') {
    dl = chineseTraditionalLocale;
  } else {
    dl = DurationLocale.fromLanguageCode(l.languageCode);
    dl ??= englishLocale;
  }
  return prettyDuration(duration, locale: dl);
}

/// formatWeekday convert date to local weekday string
/// ```dart
/// expect(formatWeekday(date), 'Monday');
/// ```
String formatWeekday(DateTime date) {
  return DateFormat.EEEE(localeName).format(date);
}

/// formatWeekdayShort convert date to local weekday short string
/// ```dart
/// expect(formatWeekdayShort(date), 'Monday');
/// ```
String formatWeekdayShort(DateTime date) {
  return DateFormat.E(localeName).format(date);
}

/// prettyWeekday convert date to local weekday string but show yesterday, today and tomorrow
/// ```dart
/// expect(prettyWeekday(date), 'Monday');
/// ```
String prettyWeekday(BuildContext context, DateTime date) {
  if (date.isToday) return context.i18n.today;
  if (date.isTomorrow) return context.i18n.tomorrow;
  if (date.isYesterday) return context.i18n.yesterday;
  return formatWeekday(date);
}

/// prettyWeekdayShort convert date to local weekday short string but show yesterday, today and tomorrow
/// ```dart
/// expect(prettyWeekdayShort(date), 'Monday');
/// ```
String prettyWeekdayShort(BuildContext context, DateTime date) {
  if (date.isToday) return context.i18n.today;
  if (date.isTomorrow) return context.i18n.tomorrow;
  if (date.isYesterday) return context.i18n.yesterday;
  return formatWeekdayShort(date);
}
