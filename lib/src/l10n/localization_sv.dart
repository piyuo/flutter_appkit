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
      'Ett oväntat fel inträffade. Vi har redan loggat detta fel. Försök igen senare.';

  @override
  String get error_oops => 'Hoppsan, något gick fel';

  @override
  String get language => 'Systemspråk';
}
