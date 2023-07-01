import 'package:libcli/google/google.dart' as google;
import 'package:libcli/i18n/i18n.dart' as i18n;

extension DatetimeHelpers on DateTime {
  /// timestamp create utc timestamp
  /// ```dart
  /// var t = date.timestamp;
  /// ```
  google.Timestamp get timestamp => google.Timestamp.fromDateTime(toUtc());
}

extension TimestampHelper on google.Timestamp {
  /// add duration to timestamp
  google.Timestamp add(Duration duration) => localDateTime.add(duration).timestamp;

  /// isAfter Returns true if [this] occurs after [other].
  bool isAfter(google.Timestamp other) => toDateTime().isAfter(other.toDateTime());

  /// isBefore Returns true if [this] occurs before [other].
  bool isBefore(google.Timestamp other) => toDateTime().isBefore(other.toDateTime());

  /// isAtSameMomentAs Returns true if [this] occurs at the same moment as [other].
  bool isAtSameMomentAs(google.Timestamp other) => toDateTime().isAtSameMomentAs(other.toDateTime());

  /// isSameDay return true if the date is same day with other day. (ignore time)
  bool isSameDay(google.Timestamp other) => localDateTime.isSameDay(other.localDateTime);

  /// localDateTime return local date time
  DateTime get localDateTime => toDateTime().toLocal();

  /// formattedDate return formatted date string
  /// ```dart
  /// expect(timestamp.formattedDate, 'Jan 2, 2021');
  /// ```
  String get formattedDate => localDateTime.formattedDate;

  /// formatTime return formatted time string
  /// ```dart
  /// var str = formatTimeStamp(stamp);
  /// expect(str, '11:30 PM');
  /// ```
  String get formattedTime => localDateTime.formattedTime;

  /// formattedDateTime return formatted date and time string
  /// ```dart
  /// expect(date.formattedDateTime, 'January 2, 2021 11:30 PM');
  /// ```
  String get formattedDateTime => localDateTime.formattedDateTime;

  /// formattedMonthDay convert date to month and day string
  String get formattedMonthDay => localDateTime.formattedMonthDay;

  /// formattedMonth get formatted month
  /// ```dart
  /// expect(date.formattedMonth, 'January');
  /// ```
  String get formattedMonth => localDateTime.formattedMonth;

  /// formattedDay convert date to day string
  /// ```dart
  /// expect(date.formattedDay, '2');
  /// ```
  String get formattedDay => localDateTime.formattedDay;

  /// formattedYear convert date to year string
  /// ```dart
  /// expect(date.formattedYear, '2023');
  /// ```
  String get formattedYear => localDateTime.formattedYear;

  /// formattedMonthShort get month short name from date
  /// ```dart
  /// expect(date.formattedMonthShort, 'Jan');
  /// ```
  String get formattedMonthShort => localDateTime.formattedMonthShort;

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

  /// formattedWeekdayAware convert date to local weekday string but show yesterday, today and tomorrow
  /// ```dart
  /// expect(date.formattedWeekdayAware(context), 'Monday');
  /// ```
  String formattedWeekdayAware(context) => localDateTime.formattedWeekdayAware(context);

  /// formattedWeekdayAwareShort convert date to local weekday short string but show yesterday, today and tomorrow
  /// ```dart
  /// expect(formattedWeekdayAwareShort(context), 'Mon');
  /// ```
  String formattedWeekdayAwareShort(context) => localDateTime.formattedWeekdayAwareShort(context);
}
