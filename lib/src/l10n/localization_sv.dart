// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class LocalizationSv extends Localization {
  LocalizationSv([String locale = 'sv']) : super(locale);

  @override
  String get close => 'Stäng';

  @override
  String get error_content =>
      'Ett oväntat fel inträffade. Du kan skicka oss en rapport för att hjälpa oss förbättra, eller försök igen senare.';

  @override
  String get error_oops => 'Hoppsan, något gick fel';

  @override
  String get error_report_anonymously =>
      'Hjälp oss förbättra genom att skicka en anonym rapport';

  @override
  String get language => 'Systemspråk';
}
