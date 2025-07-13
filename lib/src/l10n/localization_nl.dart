// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class LocalizationNl extends Localization {
  LocalizationNl([String locale = 'nl']) : super(locale);

  @override
  String get close => 'Sluiten';

  @override
  String get error_content =>
      'Er is een onverwachte fout opgetreden. We hebben deze fout al gelogd. Probeer het later opnieuw.';

  @override
  String get error_oops => 'Oeps, er is iets misgegaan';

  @override
  String get language => 'Systeemtaal';
}

/// The translations for Dutch Flemish, as used in Belgium (`nl_BE`).
class LocalizationNlBe extends LocalizationNl {
  LocalizationNlBe() : super('nl_BE');

  @override
  String get close => 'Sluiten';

  @override
  String get error_content =>
      'Er is een onverwachte fout opgetreden. We hebben deze fout al gelogd. Probeer het later opnieuw.';

  @override
  String get error_oops => 'Oeps, er is iets misgelopen';

  @override
  String get language => 'Systeemtaal';
}
