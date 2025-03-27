// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class LocalizationDe extends Localization {
  LocalizationDe([String locale = 'de']) : super(locale);

  @override
  String get cli_error_oops => 'Hoppla, etwas ist schiefgelaufen';

  @override
  String get cli_error_content => 'Ein unerwarteter Fehler ist aufgetreten. Möchten Sie einen Fehlerbericht per E-Mail senden?';

  @override
  String get cli_error_report => 'E-Mail an uns';

  @override
  String get submit => 'Absenden';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get close => 'Schließen';

  @override
  String get back => 'Zurück';

  @override
  String get system_language => 'Systemsprache';
}

/// The translations for German, as used in Austria (`de_AT`).
class LocalizationDeAt extends LocalizationDe {
  LocalizationDeAt(): super('de_AT');

  @override
  String get cli_error_oops => 'Hoppla, etwas ist schiefgelaufen';

  @override
  String get cli_error_content => 'Ein unerwarteter Fehler ist aufgetreten. Möchten Sie einen Fehlerbericht per E-Mail senden?';

  @override
  String get cli_error_report => 'E-Mail an uns';

  @override
  String get submit => 'Absenden';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get close => 'Schließen';

  @override
  String get back => 'Zurück';

  @override
  String get system_language => 'Systemsprache';
}

/// The translations for German, as used in Switzerland (`de_CH`).
class LocalizationDeCh extends LocalizationDe {
  LocalizationDeCh(): super('de_CH');

  @override
  String get cli_error_oops => 'Hoppla, etwas ist schiefgelaufen';

  @override
  String get cli_error_content => 'Ein unerwarteter Fehler ist aufgetreten. Möchten Sie einen Fehlerbericht per E-Mail senden?';

  @override
  String get cli_error_report => 'E-Mail an uns';

  @override
  String get submit => 'Absenden';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get close => 'Schliessen';

  @override
  String get back => 'Zurück';

  @override
  String get system_language => 'Systemsprache';
}
