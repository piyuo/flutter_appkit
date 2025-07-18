// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class LocalizationLt extends Localization {
  LocalizationLt([String locale = 'lt']) : super(locale);

  @override
  String get close => 'Uždaryti';

  @override
  String get error_content =>
      'Įvyko netikėta klaida. Galite atsiųsti mums ataskatą, kad padėtumėte mums tobulėti, arba bandyti dar kartą vėliau.';

  @override
  String get error_oops => 'Oi, kažkas nutiko';

  @override
  String get error_report_anonymously =>
      'Padėkite mums tobulėti siųsdami anoniminę ataskaitą';

  @override
  String get language => 'Sistemos kalba';
}
