// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class LocalizationCs extends Localization {
  LocalizationCs([String locale = 'cs']) : super(locale);

  @override
  String get cli_error_oops => 'Jejda, něco se pokazilo';

  @override
  String get cli_error_content => 'Došlo k neočekávané chybě. Chcete odeslat zprávu e-mailem?';

  @override
  String get cli_error_report => 'Napište nám';

  @override
  String get submit => 'Odeslat';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Zrušit';

  @override
  String get yes => 'Ano';

  @override
  String get no => 'Ne';

  @override
  String get close => 'Zavřít';

  @override
  String get back => 'Zpět';
}
