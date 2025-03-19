// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LocalizationEn extends Localization {
  LocalizationEn([String locale = 'en']) : super(locale);

  @override
  String get cli_error_oops => 'Oops, something went wrong';

  @override
  String get cli_error_content => 'An unexpected error occurred. Would you like to submit a email report?';

  @override
  String get cli_error_report => 'Email us';

  @override
  String get submit => 'Submit';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';
}
