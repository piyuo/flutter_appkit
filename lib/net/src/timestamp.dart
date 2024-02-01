import 'package:libcli/google/google.dart' as google;
import 'package:libcli/i18n/i18n.dart' as i18n;

/// [fromIso8601String] parse iso8601 string to timestamp
google.Timestamp fromIso8601String(String formattedString) {
  return DateTime.parse(formattedString).timestamp;
}

extension DatetimeHelpers on DateTime {
  /// fixedTimestamp create utc timestamp only use date's year, month and day
  /// ```dart
  /// var t = date.fixedTimestamp;
  /// ```
  google.Timestamp get fixedTimestamp => google.Timestamp.fromDateTime(DateTime.utc(year, month, day));

  /// timestamp create utc timestamp
  /// ```dart
  /// var t = date.timestamp;
  /// ```
  google.Timestamp get timestamp => google.Timestamp.fromDateTime(toUtc());
}

extension TimestampHelper on google.Timestamp {
  /// dateOnly return date only timestamp
  google.Timestamp get dateOnly => localDateTime.dateOnly.timestamp;

  /// [fixedDate] Returns the fixed date portion of the timestamp.
  ///
  /// The fixed date is obtained by extracting the year, month, and day from the timestamp.
  /// The time portion of the timestamp is ignored.
  DateTime get fixedDate {
    final dt = toDateTime();
    return DateTime(dt.year, dt.month, dt.day);
  }

  /// formattedDate return formatted date string
  /// ```dart
  /// expect(timestamp.formattedDate, 'Jan 2, 2021');
  /// ```
  String get formattedDate => localDateTime.formattedDate;

  /// formattedDateTime return formatted date and time string
  /// ```dart
  /// expect(date.formattedDateTime, 'January 2, 2021 11:30 PM');
  /// ```
  String get formattedDateTime => localDateTime.formattedDateTime;

  /// formattedDay convert date to day string
  /// ```dart
  /// expect(date.formattedDay, '2');
  /// ```
  String get formattedDay => localDateTime.formattedDay;

  /// formattedMonth get formatted month
  /// ```dart
  /// expect(date.formattedMonth, 'January');
  /// ```
  String get formattedMonth => localDateTime.formattedMonth;

  /// formattedMonthDay convert date to month and day string
  String get formattedMonthDay => localDateTime.formattedMonthDay;

  /// formattedMonthShort get month short name from date
  /// ```dart
  /// expect(date.formattedMonthShort, 'Jan');
  /// ```
  String get formattedMonthShort => localDateTime.formattedMonthShort;

  /// formatTime return formatted time string
  /// ```dart
  /// var str = formatTimeStamp(stamp);
  /// expect(str, '11:30 PM');
  /// ```
  String get formattedTime => localDateTime.formattedTime;

  /// formattedWeekday return weekday string
  /// ```dart
  /// expect(date.formattedWeekday, 'Monday');
  /// ```
  String get formattedWeekday => localDateTime.formattedWeekday;

  /// formattedWeekdayShort return short weekday string
  /// ```dart
  /// expect(date.formattedWeekdayShort, 'Mon');
  /// ```
  String get formattedWeekdayShort => localDateTime.formattedWeekdayShort;

  /// [formattedWeekdayShortMonthDay] convert date to weekday short and month day string
  /// ```dart
  /// expect(DateTime(2023, 1, 16).timestamp.formattedWeekdayShortMonthDay, 'Mon, Jan 16');
  /// ```
  String get formattedWeekdayShortMonthDay => '$formattedWeekdayShort, $formattedMonthDay';

  /// [formattedWeekdayShortMonthDayTime] convert date to weekday short and month day time string
  /// ```dart
  /// expect(DateTime(2023, 1, 16, 17, 23).timestamp.formattedWeekdayShortMonthDayTime, 'Mon, Jan 16, 5:23 PM');
  /// ```
  String get formattedWeekdayShortMonthDayTime => '$formattedWeekdayShort, $formattedMonthDay, $formattedTime';

  /// formattedYear convert date to year string
  /// ```dart
  /// expect(date.formattedYear, '2023');
  /// ```
  String get formattedYear => localDateTime.formattedYear;

  /// localDateTime return local date time
  DateTime get localDateTime => toDateTime().toLocal();

  /// add duration to timestamp
  google.Timestamp add(Duration duration) => localDateTime.add(duration).timestamp;

  /// formattedWeekdayAware convert date to local weekday string but show yesterday, today and tomorrow
  /// ```dart
  /// expect(date.formattedWeekdayAware(context), 'Monday');
  /// ```
  String formattedWeekdayAware(context) => localDateTime.formattedWeekdayAware(context);

  /// [formattedWeekdayAwareShort] convert date to local weekday short string but show yesterday, today and tomorrow
  /// ```dart
  /// expect(formattedWeekdayAwareShort(context), 'Mon');
  /// ```
  String formattedWeekdayAwareShort(context) => localDateTime.formattedWeekdayAwareShort(context);

  /// isAfter Returns true if [this] occurs after [other].
  bool isAfter(google.Timestamp other) => toDateTime().isAfter(other.toDateTime());

  /// isAtSameMomentAs Returns true if [this] occurs at the same moment as [other].
  bool isAtSameMomentAs(google.Timestamp other) => toDateTime().isAtSameMomentAs(other.toDateTime());

  /// isBefore Returns true if [this] occurs before [other].
  bool isBefore(google.Timestamp other) => toDateTime().isBefore(other.toDateTime());

  /// isSameDay return true if the date is same day with other day. (ignore time)
  bool isSameDay(google.Timestamp other) => localDateTime.isSameDay(other.localDateTime);

  /// [toIso8601String convert] timestamp to iso8601 string
  String toIso8601String() => toDateTime().toIso8601String();
}
