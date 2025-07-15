// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class LocalizationKk extends Localization {
  LocalizationKk([String locale = 'kk']) : super(locale);

  @override
  String get close => 'Жабу';

  @override
  String get error_content =>
      'Күтпеген қате орын алды. Бізге жақсартуға көмектесу үшін есеп жібере аласыз немесе кейінірек қайталап көріңіз.';

  @override
  String get error_oops => 'Ойбай, бір нәрсе дұрыс болмады';

  @override
  String get error_report_anonymously =>
      'Анонимді есеп жіберу арқылы жақсартуға көмектесіңіз';

  @override
  String get language => 'Жүйе тілі';
}
