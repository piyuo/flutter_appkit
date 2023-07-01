import 'package:intl/intl.dart';
import 'i18n.dart';

/// StringHelpers define string datetime helpers
extension StringHelpers on String {
  /// parseDate parse yMMMMd string to date
  /// ```dart
  /// expect('January 2, 2021'.parseDate.year, 2021);
  /// ```
  DateTime get parseDate => DateFormat.yMMMMd(localeKey).parse(this);

  /// parseDateTime parse string to date and time
  /// ```dart
  /// expect('January 2, 2021 11:30 PM'.parseDateTime.year, 2021);
  /// ```
  DateTime get parseDateTime => DateFormat.yMMMMd(localeKey).add_jm().parse(this);

  /// parseTime parse string to time
  /// ```dart
  /// '11:30 PM'.parseTime;
  /// ```
  DateTime get parseTime => DateFormat.jm(localeKey).parse(this);
}
