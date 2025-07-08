// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class LocalizationNb extends Localization {
  LocalizationNb([String locale = 'nb']) : super(locale);

  @override
  String get back => 'Tilbake';

  @override
  String get cancel => 'Avbryt';

  @override
  String get close => 'Lukk';

  @override
  String get managed_error_content =>
      'Det oppstod en uventet feil. Vi har allerede loggført denne feilen. Vennligst prøv igjen senere.';

  @override
  String get managed_error_oops => 'Ups, noe gikk galt';

  @override
  String get no => 'Nei';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Send inn';

  @override
  String get system_language => 'Systemspråk';

  @override
  String get yes => 'Ja';
}
