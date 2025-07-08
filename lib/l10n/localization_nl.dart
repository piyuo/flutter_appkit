// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class LocalizationNl extends Localization {
  LocalizationNl([String locale = 'nl']) : super(locale);

  @override
  String get back => 'Terug';

  @override
  String get cancel => 'Annuleren';

  @override
  String get close => 'Sluiten';

  @override
  String get managed_error_content =>
      'Er is een onverwachte fout opgetreden. We hebben deze fout al gelogd. Probeer het later opnieuw.';

  @override
  String get managed_error_oops => 'Oeps, er is iets misgegaan';

  @override
  String get no => 'Nee';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Verzenden';

  @override
  String get system_language => 'Systeemtaal';

  @override
  String get yes => 'Ja';
}

/// The translations for Dutch Flemish, as used in Belgium (`nl_BE`).
class LocalizationNlBe extends LocalizationNl {
  LocalizationNlBe() : super('nl_BE');

  @override
  String get back => 'Terug';

  @override
  String get cancel => 'Annuleren';

  @override
  String get close => 'Sluiten';

  @override
  String get managed_error_content =>
      'Er is een onverwachte fout opgetreden. We hebben deze fout al gelogd. Probeer het later opnieuw.';

  @override
  String get managed_error_oops => 'Oeps, er is iets misgelopen';

  @override
  String get no => 'Nee';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Versturen';

  @override
  String get system_language => 'Systeemtaal';

  @override
  String get yes => 'Ja';
}
