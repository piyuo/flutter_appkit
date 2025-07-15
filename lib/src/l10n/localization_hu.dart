// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class LocalizationHu extends Localization {
  LocalizationHu([String locale = 'hu']) : super(locale);

  @override
  String get close => 'Bezárás';

  @override
  String get error_content =>
      'Váratlan hiba történt. Küldhet nekünk jelentést, hogy segítsen fejleszteni, vagy próbálja újra később.';

  @override
  String get error_oops => 'Hoppá, valami hiba történt';

  @override
  String get error_report_anonymously =>
      'Segítsen fejleszteni egy névtelen jelentés küldésével';

  @override
  String get language => 'Rendszer nyelve';
}
