// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class LocalizationDe extends Localization {
  LocalizationDe([String locale = 'de']) : super(locale);

  @override
  String get close => 'Schließen';

  @override
  String get error_content =>
      'Ein unerwarteter Fehler ist aufgetreten. Wir haben diesen Fehler bereits protokolliert. Bitte versuchen Sie es später erneut.';

  @override
  String get error_oops => 'Hoppla, etwas ist schiefgelaufen';

  @override
  String get language => 'Systemsprache';
}

/// The translations for German, as used in Austria (`de_AT`).
class LocalizationDeAt extends LocalizationDe {
  LocalizationDeAt() : super('de_AT');

  @override
  String get close => 'Schließen';

  @override
  String get error_content =>
      'Ein unerwarteter Fehler ist aufgetreten. Wir haben diesen Fehler bereits protokolliert. Bitte versuchen Sie es später erneut.';

  @override
  String get error_oops => 'Hoppla, etwas ist schiefgelaufen';

  @override
  String get language => 'Systemsprache';
}

/// The translations for German, as used in Switzerland (`de_CH`).
class LocalizationDeCh extends LocalizationDe {
  LocalizationDeCh() : super('de_CH');

  @override
  String get close => 'Schliessen';

  @override
  String get error_content =>
      'Ein unerwarteter Fehler ist aufgetreten. Wir haben diesen Fehler bereits protokolliert. Bitte versuchen Sie es später erneut.';

  @override
  String get error_oops => 'Hoppla, etwas ist schiefgelaufen';

  @override
  String get language => 'Systemsprache';
}
