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
      '\'n Onverwagse fout het voorgekom. Jy kan vir ons \'n verslag stuur om ons te help verbeter, of probeer later weer.';

  @override
  String get error_oops => 'Oeps, iets het verkeerd gegaan';

  @override
  String get error_report_anonymously =>
      'Help ons verbeteren door \'n anonieme verslag te stuur';

  @override
  String get language => 'Stelsel Taal';
}
