// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class LocalizationSk extends Localization {
  LocalizationSk([String locale = 'sk']) : super(locale);

  @override
  String get cli_error_oops => 'Ups, niečo sa pokazilo';

  @override
  String get cli_error_content => 'Vyskytla sa neočakávaná chyba. Chcete odoslať e-mailovú správu?';

  @override
  String get cli_error_report => 'Napíšte nám e-mail';

  @override
  String get submit => 'Odoslať';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get yes => 'Áno';

  @override
  String get no => 'Nie';

  @override
  String get close => 'Zatvoriť';

  @override
  String get back => 'Späť';
}
