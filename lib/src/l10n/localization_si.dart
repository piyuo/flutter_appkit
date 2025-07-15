// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class LocalizationSi extends Localization {
  LocalizationSi([String locale = 'si']) : super(locale);

  @override
  String get close => 'වසන්න';

  @override
  String get error_content =>
      'අනපේක්ෂිත දෝෂයක් සිදුවිය. අපට වැඩිදියුණු වීමට උදව් කිරීම සඳහා ඔබට අපට වාර්තාවක් එවිය හැක, නැතහොත් පසුව නැවත උත්සාහ කරන්න.';

  @override
  String get error_oops => 'අයියෝ, යමක් වැරදී ඇත';

  @override
  String get error_report_anonymously =>
      'නිර්නාමික වාර්තාවක් එවීමෙන් අපට වැඩිදියුණු වීමට උදව් කරන්න';

  @override
  String get language => 'පද්ධති භාෂාව';
}
