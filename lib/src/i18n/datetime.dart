import 'package:intl/intl.dart';
import 'package:libcli/src/i18n/i18n.dart';
import 'package:intl/date_symbol_data_local.dart';

/// changeDateFormatting change locale and load date formatting resource
///
///     await changeDateFormatting('en_US');
///
Future<void> changeDateFormatting(String locale) async {
  Intl.defaultLocale = locale;
  await initializeDateFormatting(locale, null);
}

/// dateFormat return current date format
///
DateFormat get dateFormat {
  return DateFormat.yMMMMd(localeName);
}

/// datePattern return current date pattern
///
///     expect(datePattern, 'MMMM d, y');
///
String get datePattern {
  return dateFormat.pattern ?? '';
}

/// timeFormat return current time format
///
DateFormat get timeFormat {
  return DateFormat.jm(localeName);
}

/// timePattern return current time pattern
///
///     expect(timePattern, 'h:mm a');
///
String get timePattern {
  return timeFormat.pattern ?? '';
}

/// dateTimeFormat return current date time format
///
DateFormat get dateTimeFormat {
  return DateFormat.yMMMMd(localeName).add_jm();
}

/// dateTimePattern return current date time pattern
///
///      expect(dateTimePattern, 'MMMM d, y h:mm a');
///
String get dateTimePattern {
  return dateTimeFormat.pattern ?? '';
}

/// formatTimeFixed convert hour and minute to local string
///
///      var str = formatTimeFixed(07, 30);
///      expect(str, '7:30 AM');
///
String formatTimeFixed(int hour, int minute) {
  var date = DateTime.utc(2001, 1, 1, hour, minute);
  return timeFormat.format(date);
}

/// formatDate convert date to local string
///
///     var str = formatDate(date);
///     expect(str, 'Jan 2, 2021');
///
String formatDate(DateTime date) {
  return dateFormat.format(date);
}

/// parseDate parse string to date
///
///     final date = parseDate('January 2, 2021');
///     expect(date.year, 2021);
///
DateTime parseDate(String date) {
  return dateFormat.parse(date);
}

/// formatDateTime convert date and time to local string
///
///      var str = formatDateTime(date);
///      expect(str, 'January 2, 2021 11:30 PM');
///
String formatDateTime(DateTime date) {
  return dateTimeFormat.format(date);
}

/// formatTime convert time to local string
///
///     var str = formatTime(date);
///     expect(str, '11:30 PM');
///
String formatTime(DateTime date) {
  return timeFormat.format(date);
}
