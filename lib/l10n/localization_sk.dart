// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class LocalizationSk extends Localization {
  LocalizationSk([String locale = 'sk']) : super(locale);

  @override
  String get back => 'Späť';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get close => 'Zatvoriť';

  @override
  String get managed_error_content =>
      'Vyskytla sa neočakávaná chyba. Túto chybu sme už zaznamenali. Skúste to neskôr znovu.';

  @override
  String get managed_error_oops => 'Ups, niečo sa pokazilo';

  @override
  String get no => 'Nie';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Odoslať';

  @override
  String get system_language => 'Systémový jazyk';

  @override
  String get yes => 'Áno';
}
