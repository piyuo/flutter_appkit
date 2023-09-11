import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'i18n.dart';

/// minDateTime return the minimum date
DateTime get minDateTime => DateTime.utc(-271821, 04, 20);

/// maxDateTime return the maximum date
DateTime get maxDateTime => DateTime.utc(275760, 09, 13);

/// monthDayFormat return current format only month and day
DateFormat get monthDayFormat => DateFormat.MMMd();

/// dayFormat return current format only day
DateFormat get dayFormat => DateFormat.d();

/// yearFormat return current format only year
DateFormat get yearFormat => DateFormat.y();

/// monthFormat return current format only month
DateFormat get monthFormat => DateFormat.MMM();

/// dateFormat return current date format
DateFormat get dateFormat => DateFormat.yMMMMd();

/// datePattern return current date pattern
/// ```dart
/// expect(datePattern, 'MMMM d, y');
/// ```
String get datePattern => dateFormat.pattern ?? '';

/// timeFormat return current time format
DateFormat get timeFormat => DateFormat.jm();

/// timePattern return current time pattern
/// ```dart
/// expect(timePattern, 'h:mm a');
/// ```
String get timePattern => timeFormat.pattern ?? '';

/// dateTimeFormat return current date time format
DateFormat get dateTimeFormat => DateFormat.yMMMMd().add_jm();

/// dateTimePattern return current date time pattern
/// ```dart
/// expect(dateTimePattern, 'MMMM d, y h:mm a');
/// ```
String get dateTimePattern => dateTimeFormat.pattern ?? '';

/// DatetimeHelpers define date helpers
extension DatetimeHelpers on DateTime {
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

  /// dateOnly return date without time
  /// ```dart
  /// expect(DateTime(2023, 1, 18, 23, 11).dateOnly, DateTime(2023, 1, 18));
  /// ```
  DateTime get dateOnly => DateTime(year, month, day);

  /// formattedDate return formatted date string
  /// ```dart
  /// expect(date.formattedDate, 'Jan 2, 2021');
  /// ```
  String get formattedDate => dateFormat.format(this);

  /// formattedTime convert time to local string
  /// ```dart
  /// var str = formatTime();
  /// expect(date.formattedTime, '11:30 PM');
  /// ```
  String get formattedTime => timeFormat.format(this);

  /// formattedDateTime convert date and time to local string
  /// ```dart
  /// expect(date.formattedDateTime, 'January 2, 2021 11:30 PM');
  /// ```
  String get formattedDateTime => dateTimeFormat.format(this);

  /// formattedMonthDay convert date to month and day string
  String get formattedMonthDay => DateFormat.MMMd().format(this);

  /// formattedMonth get formatted month
  /// ```dart
  /// expect(date.formattedMonth, 'January');
  /// ```
  String get formattedMonth => DateFormat.MMMM().format(this);

  /// formattedDay convert date to day string
  /// ```dart
  /// expect(date.formattedDay, '2');
  /// ```
  String get formattedDay => dayFormat.format(this);

  /// formattedYear convert date to year string
  /// ```dart
  /// expect(date.formattedYear, '2023');
  /// ```
  String get formattedYear => yearFormat.format(this);

  /// formattedMonthShort get month short name from date
  /// ```dart
  /// expect(date.formattedMonthShort, 'Jan');
  /// ```
  String get formattedMonthShort => DateFormat.MMM().format(this);

  /// formattedWeekday return weekday string
  /// ```dart
  /// expect(date.formattedWeekday, 'Monday');
  /// ```
  String get formattedWeekday => DateFormat.EEEE().format(this);

  /// formattedWeekdayShort return short weekday string
  /// ```dart
  /// expect(date.formattedWeekdayShort, 'Mon');
  /// ```
  String get formattedWeekdayShort => DateFormat.E().format(this);

  /// formattedWeekdayAware convert date to local weekday string but show yesterday, today and tomorrow
  /// ```dart
  /// expect(date.formattedWeekdayAware(context), 'Monday');
  /// ```
  String formattedWeekdayAware(BuildContext context) {
    if (isToday) return context.i18n.today;
    if (isTomorrow) return context.i18n.tomorrow;
    if (isYesterday) return context.i18n.yesterday;
    return formattedWeekday;
  }

  /// formattedWeekdayAwareShort convert date to local weekday short string but show yesterday, today and tomorrow
  /// ```dart
  /// expect(formattedWeekdayAwareShort(context), 'Mon');
  /// ```
  String formattedWeekdayAwareShort(BuildContext context) {
    if (isToday) return context.i18n.today;
    if (isTomorrow) return context.i18n.tomorrow;
    if (isYesterday) return context.i18n.yesterday;
    return formattedWeekdayShort;
  }

  /// formattedWeekdayShortMonthDay convert date to weekday short and month day string
  /// ```dart
  /// expect(DateTime(2023, 1, 16).formattedWeekdayShortMonthDay, 'Mon, Jan 16');
  /// ```
  String get formattedWeekdayShortMonthDay => '$formattedWeekdayShort, $formattedMonthDay';

  /// formattedWeekdayShortMonthDayTime convert date to weekday short and month day time string
  /// ```dart
  /// expect(DateTime(2023, 1, 16, 17, 23).formattedWeekdayShortMonthDayTime, 'Mon, Jan 16, 5:23 PM');
  /// ```
  String get formattedWeekdayShortMonthDayTime => '$formattedWeekdayShort, $formattedMonthDay, $formattedTime';
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
