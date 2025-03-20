// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Hausa (`ha`).
class LocalizationHa extends Localization {
  LocalizationHa([String locale = 'ha']) : super(locale);

  @override
  String get cli_error_oops => 'Kash, akwai wani abu da ya faru';

  @override
  String get cli_error_content => 'An sami kuskure da ba a sani ba. Kana son aika rahoton imel?';

  @override
  String get cli_error_report => 'Aika mana imel';

  @override
  String get submit => 'Aika';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Soke';

  @override
  String get yes => 'Ee';

  @override
  String get no => 'A\'a';

  @override
  String get close => 'Rufe';

  @override
  String get back => 'Koma';
}
