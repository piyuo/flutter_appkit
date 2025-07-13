// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class LocalizationCs extends Localization {
  LocalizationCs([String locale = 'cs']) : super(locale);

  @override
  String get close => 'Zavřít';

  @override
  String get error_content =>
      'Došlo k neočekávané chybě. Tuto chybu jsme již zaznamenali. Zkuste to prosím znovu později.';

  @override
  String get error_oops => 'Jejda, něco se pokazilo';

  @override
  String get language => 'Systémový jazyk';
}
