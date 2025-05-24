// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class LocalizationFi extends Localization {
  LocalizationFi([String locale = 'fi']) : super(locale);

  @override
  String get cli_error_oops => 'Hups, jokin meni pieleen';

  @override
  String get cli_error_content =>
      'Tapahtui odottamaton virhe. Haluatko lähettää sähköpostiraportin?';

  @override
  String get cli_error_report => 'Lähetä meille sähköpostia';

  @override
  String get submit => 'Lähetä';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Peruuta';

  @override
  String get yes => 'Kyllä';

  @override
  String get no => 'Ei';

  @override
  String get close => 'Sulje';

  @override
  String get back => 'Takaisin';

  @override
  String get system_language => 'Järjestelmän kieli';
}
