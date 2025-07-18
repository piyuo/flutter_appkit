// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class LocalizationRo extends Localization {
  LocalizationRo([String locale = 'ro']) : super(locale);

  @override
  String get close => 'Închide';

  @override
  String get error_content =>
      'A apărut o eroare neașteptată. Ne puteți trimite un raport pentru a ne ajuta să ne îmbunătățim, sau încercați din nou mai târziu.';

  @override
  String get error_oops => 'Ups, ceva nu a funcționat';

  @override
  String get error_report_anonymously =>
      'Ajutați-ne să ne îmbunătățim trimițând un raport anonim';

  @override
  String get language => 'Limba sistemului';
}
