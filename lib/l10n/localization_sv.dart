// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class LocalizationSv extends Localization {
  LocalizationSv([String locale = 'sv']) : super(locale);

  @override
  String get cli_error_oops => 'Hoppsan, något gick fel';

  @override
  String get cli_error_content => 'Ett oväntat fel inträffade. Vill du skicka en rapport via e-post?';

  @override
  String get cli_error_report => 'Mejla oss';

  @override
  String get submit => 'Skicka';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Avbryt';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nej';

  @override
  String get close => 'Stäng';

  @override
  String get back => 'Tillbaka';
}
