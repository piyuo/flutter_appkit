// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class LocalizationLt extends Localization {
  LocalizationLt([String locale = 'lt']) : super(locale);

  @override
  String get cli_error_oops => 'Oi, kažkas nutiko';

  @override
  String get cli_error_content =>
      'Įvyko netikėta klaida. Ar norėtumėte pateikti el. pašto ataskaitą?';

  @override
  String get cli_error_report => 'Susisiekite el. paštu';

  @override
  String get submit => 'Pateikti';

  @override
  String get ok => 'Gerai';

  @override
  String get cancel => 'Atšaukti';

  @override
  String get yes => 'Taip';

  @override
  String get no => 'Ne';

  @override
  String get close => 'Uždaryti';

  @override
  String get back => 'Atgal';

  @override
  String get system_language => 'Sistemos kalba';
}
