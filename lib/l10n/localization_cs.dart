// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class LocalizationCs extends Localization {
  LocalizationCs([String locale = 'cs']) : super(locale);

  @override
  String get back => 'Zpět';

  @override
  String get cancel => 'Zrušit';

  @override
  String get close => 'Zavřít';

  @override
  String get managed_error_content =>
      'Došlo k neočekávané chybě. Tuto chybu jsme již zaznamenali. Zkuste to prosím znovu později.';

  @override
  String get managed_error_oops => 'Jejda, něco se pokazilo';

  @override
  String get no => 'Ne';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Odeslat';

  @override
  String get system_language => 'Systémový jazyk';

  @override
  String get yes => 'Ano';
}
