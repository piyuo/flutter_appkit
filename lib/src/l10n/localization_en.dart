// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LocalizationEn extends Localization {
  LocalizationEn([String locale = 'en']) : super(locale);

  @override
  String get close => 'Close';

  @override
  String get error_content =>
      'An unexpected error occurred. You can send us a report to help us improve, or try again later.';

  @override
  String get error_oops => 'Oops, something went wrong';

  @override
  String get error_report_anonymously =>
      'Help us improve by sending an anonymous report';

  @override
  String get language => 'System Language';
}

/// The translations for English, as used in Australia (`en_AU`).
class LocalizationEnAu extends LocalizationEn {
  LocalizationEnAu() : super('en_AU');

  @override
  String get close => 'Close';

  @override
  String get error_content =>
      'An unexpected error occurred. You can send us a report to help us improve, or try again later.';

  @override
  String get error_oops => 'Oops, something went wrong';

  @override
  String get error_report_anonymously =>
      'Help us improve by sending an anonymous report';

  @override
  String get language => 'System Language';
}

/// The translations for English, as used in Canada (`en_CA`).
class LocalizationEnCa extends LocalizationEn {
  LocalizationEnCa() : super('en_CA');

  @override
  String get close => 'Close';

  @override
  String get error_content =>
      'An unexpected error occurred. You can send us a report to help us improve, or try again later.';

  @override
  String get error_oops => 'Oops, something went wrong';

  @override
  String get error_report_anonymously =>
      'Help us improve by sending an anonymous report';

  @override
  String get language => 'System Language';
}

/// The translations for English, as used in the United Kingdom (`en_GB`).
class LocalizationEnGb extends LocalizationEn {
  LocalizationEnGb() : super('en_GB');

  @override
  String get close => 'Close';

  @override
  String get error_content =>
      'An unexpected error occurred. You can send us a report to help us improve, or try again later.';

  @override
  String get error_oops => 'Oops, something went wrong';

  @override
  String get error_report_anonymously =>
      'Help us improve by sending an anonymous report';

  @override
  String get language => 'System Language';
}

/// The translations for English, as used in India (`en_IN`).
class LocalizationEnIn extends LocalizationEn {
  LocalizationEnIn() : super('en_IN');

  @override
  String get close => 'Close';

  @override
  String get error_content =>
      'An unexpected error occurred. You can send us a report to help us improve, or try again later.';

  @override
  String get error_oops => 'Oops, something went wrong';

  @override
  String get error_report_anonymously =>
      'Help us improve by sending an anonymous report';

  @override
  String get language => 'System Language';
}
