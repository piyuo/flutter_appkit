// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Afrikaans (`af`).
class LocalizationAf extends Localization {
  LocalizationAf([String locale = 'af']) : super(locale);

  @override
  String get cli_error_oops => 'Oeps, iets het verkeerd gegaan';

  @override
  String get cli_error_content =>
      '\'n Onverwagse fout het voorgekom. Wil jy \'n e-posverslag indien?';

  @override
  String get cli_error_report => 'E-pos ons';

  @override
  String get submit => 'Indien';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Kanselleer';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get close => 'Sluit';

  @override
  String get back => 'Terug';

  @override
  String get system_language => 'Stelsel Taal';
}
