// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class LocalizationSi extends Localization {
  LocalizationSi([String locale = 'si']) : super(locale);

  @override
  String get cli_error_oops => 'අයියෝ, යමක් වැරදී ඇත';

  @override
  String get cli_error_content => 'අනපේක්ෂිත දෝෂයක් සිදුවිය. ඔබට විද්‍යුත් තැපැල් වාර්තාවක් ඉදිරිපත් කිරීමට අවශ්‍යද?';

  @override
  String get cli_error_report => 'අපට ඊමේල් කරන්න';

  @override
  String get submit => 'ඉදිරිපත් කරන්න';

  @override
  String get ok => 'හරි';

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get yes => 'ඔව්';

  @override
  String get no => 'නැත';

  @override
  String get close => 'වසන්න';

  @override
  String get back => 'ආපසු';
}
