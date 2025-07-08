// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class LocalizationRo extends Localization {
  LocalizationRo([String locale = 'ro']) : super(locale);

  @override
  String get back => 'Înapoi';

  @override
  String get cancel => 'Anulează';

  @override
  String get close => 'Închide';

  @override
  String get managed_error_content =>
      'A apărut o eroare neașteptată. Am înregistrat deja această eroare. Vă rugăm să încercați din nou mai târziu.';

  @override
  String get managed_error_oops => 'Ups, ceva nu a funcționat';

  @override
  String get no => 'Nu';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Trimite';

  @override
  String get system_language => 'Limba sistemului';

  @override
  String get yes => 'Da';
}
