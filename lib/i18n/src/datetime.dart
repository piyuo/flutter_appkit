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

  /// dateName return localized date string
  /// ```dart
  /// expect(date.dateName, 'January');
  /// ```
  String get dateName => formatDate(this);

  /// dateTimeName return localized date string
  /// ```dart
  /// expect(date.dateTimeName, 'January');
  /// ```
  String get dateTimeName => formatDateTime(this);

  /// timeName return localized date string
  /// ```dart
  /// expect(date.timeName, 'January');
  /// ```
  String get timeName => formatTime(this);

  /// monthName get month name from date
  /// ```dart
  /// expect(date.monthName, 'January');
  /// ```
  String get monthName => getMonthName(this);

  /// monthNameShort get month short name from date
  /// ```dart
  /// expect(date.monthNameShort, 'Jan');
  /// ```
  String get monthNameShort => getMonthNameShort(this);

  /// weekdayName return weekday string
  /// ```dart
  /// expect(date.weekdayName, 'Monday');
  /// ```
  String get weekdayName => formatWeekday(this);

  /// weekdayNameShort get short weekday string
  /// ```dart
  /// expect(date.weekdayNameShort, 'Mon');
  /// ```
  String get weekdayNameShort => formatWeekdayShort(this);

  /// prettyWeekdayName return pretty weekday string
  /// ```dart
  /// expect(date.prettyWeekdayName, 'Monday');
  /// ```
  String prettyWeekdayName(context) => formatPrettyWeekday(context, this);

  /// prettyWeekdayNameShort get pretty short weekday string
  /// ```dart
  /// expect(date.prettyWeekdayNameShort, 'Mon');
  /// ```
  String prettyWeekdayNameShort(context) => formatPrettyWeekdayShort(context, this);
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
DateFormat get dateFormat => DateFormat.yMMMMd(localeKey);

/// datePattern return current date pattern
/// ```dart
/// expect(datePattern, 'MMMM d, y');
/// ```
String get datePattern => dateFormat.pattern ?? '';

/// timeFormat return current time format
DateFormat get timeFormat => DateFormat.jm(localeKey);

/// timePattern return current time pattern
/// ```dart
/// expect(timePattern, 'h:mm a');
/// ```
String get timePattern => timeFormat.pattern ?? '';

/// dateTimeFormat return current date time format
DateFormat get dateTimeFormat => DateFormat.yMMMMd(localeKey).add_jm();

/// dateTimePattern return current date time pattern
/// ```dart
/// expect(dateTimePattern, 'MMMM d, y h:mm a');
/// ```
String get dateTimePattern => dateTimeFormat.pattern ?? '';

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

/// getMonthName get month name from date
/// ```dart
/// var str = getMonthName(date);
/// expect(str, 'January');
/// ```
String getMonthName(DateTime date) => DateFormat.MMMM(localeKey).format(date);

/// getMonthNameShort get month short name from date
/// ```dart
/// var str = getMonthNameShort(date);
/// expect(str, 'Jan');
/// ```
String getMonthNameShort(DateTime date) => DateFormat.MMM(localeKey).format(date);

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

/// parseDateTime parse string to date and time
/// ```dart
/// final date = parseDateTime('January 2, 2021 11:30 PM');
/// expect(date.year, 2021);
/// ```
DateTime parseDateTime(String datetime) => dateTimeFormat.parse(datetime);

/// formatTime convert time to local string
/// ```dart
/// var str = formatTime(date);
/// expect(str, '11:30 PM');
/// ```
String formatTime(DateTime time) => timeFormat.format(time);

/// parseTime parse string to time
/// ```dart
/// final time = parseTime('11:30 PM');
/// ```
DateTime parseTime(String datetime) => timeFormat.parse(datetime);

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
  if (localeKey == 'zh_TW') {
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
String formatWeekday(DateTime date) => DateFormat.EEEE(localeKey).format(date);

/// formatWeekdayShort convert date to local weekday short string
/// ```dart
/// expect(formatWeekdayShort(date), 'Mon');
/// ```
String formatWeekdayShort(DateTime date) => DateFormat.E(localeKey).format(date);

/// formatPrettyWeekday convert date to local weekday string but show yesterday, today and tomorrow
/// ```dart
/// expect(prettyWeekday(date), 'Monday');
/// ```
String formatPrettyWeekday(BuildContext context, DateTime date) {
  if (date.isToday) return context.i18n.today;
  if (date.isTomorrow) return context.i18n.tomorrow;
  if (date.isYesterday) return context.i18n.yesterday;
  return formatWeekday(date);
}

/// formatPrettyWeekdayShort convert date to local weekday short string but show yesterday, today and tomorrow
/// ```dart
/// expect(prettyWeekdayShort(date), 'Monday');
/// ```
String formatPrettyWeekdayShort(BuildContext context, DateTime date) {
  if (date.isToday) return context.i18n.today;
  if (date.isTomorrow) return context.i18n.tomorrow;
  if (date.isYesterday) return context.i18n.yesterday;
  return formatWeekdayShort(date);
}
