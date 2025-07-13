// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class LocalizationSk extends Localization {
  LocalizationSk([String locale = 'sk']) : super(locale);

  @override
  String get close => 'Zatvoriť';

  @override
  String get error_content =>
      'Vyskytla sa neočakávaná chyba. Túto chybu sme už zaznamenali. Skúste to neskôr znovu.';

  @override
  String get error_oops => 'Ups, niečo sa pokazilo';

  @override
  String get language => 'Systémový jazyk';
}
