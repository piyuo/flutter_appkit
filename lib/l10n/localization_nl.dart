// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class LocalizationNl extends Localization {
  LocalizationNl([String locale = 'nl']) : super(locale);

  @override
  String get cli_error_oops => 'Oeps, er is iets misgegaan';

  @override
  String get cli_error_content => 'Er is een onverwachte fout opgetreden. Wil je een e-mailrapport sturen?';

  @override
  String get cli_error_report => 'Mail ons';

  @override
  String get submit => 'Verzenden';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuleren';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get close => 'Sluiten';

  @override
  String get back => 'Terug';
}

/// The translations for Dutch Flemish, as used in Belgium (`nl_BE`).
class LocalizationNlBe extends LocalizationNl {
  LocalizationNlBe(): super('nl_BE');

  @override
  String get cli_error_oops => 'Oeps, er is iets misgelopen';

  @override
  String get cli_error_content => 'Er is een onverwachte fout opgetreden. Wilt u een e-mailrapport versturen?';

  @override
  String get cli_error_report => 'Mail ons';

  @override
  String get submit => 'Versturen';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuleren';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get close => 'Sluiten';

  @override
  String get back => 'Terug';
}
