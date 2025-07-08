// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class LocalizationFi extends Localization {
  LocalizationFi([String locale = 'fi']) : super(locale);

  @override
  String get back => 'Takaisin';

  @override
  String get cancel => 'Peruuta';

  @override
  String get close => 'Sulje';

  @override
  String get managed_error_content =>
      'Tapahtui odottamaton virhe. Olemme jo kirjanneet tämän virheen. Yritä myöhemmin uudelleen.';

  @override
  String get managed_error_oops => 'Hups, jokin meni pieleen';

  @override
  String get no => 'Ei';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Lähetä';

  @override
  String get system_language => 'Järjestelmän kieli';

  @override
  String get yes => 'Kyllä';
}
