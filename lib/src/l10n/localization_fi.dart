// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class LocalizationFi extends Localization {
  LocalizationFi([String locale = 'fi']) : super(locale);

  @override
  String get close => 'Sulje';

  @override
  String get error_content =>
      'Tapahtui odottamaton virhe. Voit lähettää meille raportin auttaaksesi meitä parantamaan, tai yritä myöhemmin uudelleen.';

  @override
  String get error_oops => 'Hups, jokin meni pieleen';

  @override
  String get error_report_anonymously =>
      'Auta meitä parantamaan lähettämällä anonyymi raportti';

  @override
  String get language => 'Järjestelmän kieli';
}
