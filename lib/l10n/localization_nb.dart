// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class LocalizationNb extends Localization {
  LocalizationNb([String locale = 'nb']) : super(locale);

  @override
  String get cli_error_oops => 'Ups, noe gikk galt';

  @override
  String get cli_error_content => 'Det oppstod en uventet feil. Vil du sende en e-postrapport?';

  @override
  String get cli_error_report => 'Send oss e-post';

  @override
  String get submit => 'Send inn';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Avbryt';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nei';

  @override
  String get close => 'Lukk';

  @override
  String get back => 'Tilbake';

  @override
  String get system_language => 'Systemspråk';
}
