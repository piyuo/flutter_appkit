// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class LocalizationRo extends Localization {
  LocalizationRo([String locale = 'ro']) : super(locale);

  @override
  String get cli_error_oops => 'Ups, ceva nu a funcționat';

  @override
  String get cli_error_content =>
      'A apărut o eroare neașteptată. Doriți să trimiteți un raport prin e-mail?';

  @override
  String get cli_error_report => 'Trimite-ne un e-mail';

  @override
  String get submit => 'Trimite';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Anulează';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Nu';

  @override
  String get close => 'Închide';

  @override
  String get back => 'Înapoi';

  @override
  String get system_language => 'Limba sistemului';
}
