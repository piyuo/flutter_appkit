// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Nynorsk (`nn`).
class LocalizationNn extends Localization {
  LocalizationNn([String locale = 'nn']) : super(locale);

  @override
  String get cli_error_oops => 'Uff, noko gjekk gale';

  @override
  String get cli_error_content => 'Det oppstod ein uventa feil. Vil du sende ein e-postrapport?';

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
  String get system_language => 'Systemmål';
}
