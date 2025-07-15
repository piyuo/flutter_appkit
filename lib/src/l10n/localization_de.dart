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
      'Ein unerwarteter Fehler ist aufgetreten. Sie können uns einen Bericht senden, um uns zu helfen uns zu verbessern, oder versuchen Sie es später erneut.';

  @override
  String get error_oops => 'Hoppla, etwas ist schiefgelaufen';

  @override
  String get error_report_anonymously =>
      'Helfen Sie uns zu verbessern, indem Sie einen anonymen Bericht senden';

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
      'Ein unerwarteter Fehler ist aufgetreten. Sie können uns einen Bericht senden, um uns zu helfen uns zu verbessern, oder versuchen Sie es später erneut.';

  @override
  String get error_oops => 'Hoppla, etwas ist schiefgelaufen';

  @override
  String get error_report_anonymously =>
      'Helfen Sie uns zu verbessern, indem Sie einen anonymen Bericht senden';

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
      'Ein unerwarteter Fehler ist aufgetreten. Sie können uns einen Bericht senden, um uns zu helfen uns zu verbessern, oder versuchen Sie es später erneut.';

  @override
  String get error_oops => 'Hoppla, etwas ist schiefgelaufen';

  @override
  String get error_report_anonymously =>
      'Helfen Sie uns zu verbessern, indem Sie einen anonymen Bericht senden';

  @override
  String get language => 'Systemsprache';
}
