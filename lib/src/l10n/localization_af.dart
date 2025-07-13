// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Afrikaans (`af`).
class LocalizationAf extends Localization {
  LocalizationAf([String locale = 'af']) : super(locale);

  @override
  String get close => 'Sluit';

  @override
  String get error_content =>
      'An onverwagse fout het voorgekom. Ons het reeds hierdie fout aangeteken. Probeer asseblief later weer.';

  @override
  String get error_oops => 'Oeps, iets het verkeerd gegaan';

  @override
  String get language => 'Stelsel Taal';
}
