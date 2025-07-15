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
      'Er is een onverwachte fout opgetreden. Je kunt ons een rapport sturen om ons te helpen verbeteren, of probeer het later opnieuw.';

  @override
  String get error_oops => 'Oeps, er is iets misgegaan';

  @override
  String get error_report_anonymously =>
      'Help ons verbeteren door een anoniem rapport te sturen';

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
      'Er is een onverwachte fout opgetreden. Je kunt ons een rapport sturen om ons te helpen verbeteren, of probeer het later opnieuw.';

  @override
  String get error_oops => 'Oeps, er is iets misgelopen';

  @override
  String get error_report_anonymously =>
      'Help ons verbeteren door een anoniem rapport te sturen';

  @override
  String get language => 'Systeemtaal';
}
