// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class LocalizationSv extends Localization {
  LocalizationSv([String locale = 'sv']) : super(locale);

  @override
  String get back => 'Tillbaka';

  @override
  String get cancel => 'Avbryt';

  @override
  String get close => 'Stäng';

  @override
  String get managed_error_content =>
      'Ett oväntat fel inträffade. Vi har redan loggat detta fel. Försök igen senare.';

  @override
  String get managed_error_oops => 'Hoppsan, något gick fel';

  @override
  String get no => 'Nej';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Skicka';

  @override
  String get system_language => 'Systemspråk';

  @override
  String get yes => 'Ja';
}
