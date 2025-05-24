// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class LocalizationHu extends Localization {
  LocalizationHu([String locale = 'hu']) : super(locale);

  @override
  String get cli_error_oops => 'Hoppá, valami hiba történt';

  @override
  String get cli_error_content =>
      'Váratlan hiba történt. Szeretne e-mail jelentést küldeni?';

  @override
  String get cli_error_report => 'E-mail küldése nekünk';

  @override
  String get submit => 'Küldés';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Mégse';

  @override
  String get yes => 'Igen';

  @override
  String get no => 'Nem';

  @override
  String get close => 'Bezárás';

  @override
  String get back => 'Vissza';

  @override
  String get system_language => 'Rendszer nyelve';
}
