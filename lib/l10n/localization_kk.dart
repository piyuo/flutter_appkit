// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class LocalizationKk extends Localization {
  LocalizationKk([String locale = 'kk']) : super(locale);

  @override
  String get cli_error_oops => 'Ойбай, бір нәрсе дұрыс болмады';

  @override
  String get cli_error_content => 'Күтпеген қате орын алды. Электрондық пошта арқылы есеп жібергіңіз келе ме?';

  @override
  String get cli_error_report => 'Бізге электрондық хат жіберіңіз';

  @override
  String get submit => 'Жіберу';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Болдырмау';

  @override
  String get yes => 'Иә';

  @override
  String get no => 'Жоқ';

  @override
  String get close => 'Жабу';

  @override
  String get back => 'Артқа';
}
