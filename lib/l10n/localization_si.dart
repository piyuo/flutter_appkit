// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class LocalizationSi extends Localization {
  LocalizationSi([String locale = 'si']) : super(locale);

  @override
  String get back => 'ආපසු';

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get close => 'වසන්න';

  @override
  String get managed_error_content =>
      'අනපේක්ෂිත දෝෂයක් සිදුවිය. අපි මෙම දෝෂය දැනටමත් ලොග් කර ඇත. කරුණාකර පසුව නැවත උත්සාහ කරන්න.';

  @override
  String get managed_error_oops => 'අයියෝ, යමක් වැරදී ඇත';

  @override
  String get no => 'නැත';

  @override
  String get ok => 'හරි';

  @override
  String get submit => 'ඉදිරිපත් කරන්න';

  @override
  String get system_language => 'පද්ධති භාෂාව';

  @override
  String get yes => 'ඔව්';
}
