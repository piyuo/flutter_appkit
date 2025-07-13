// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class LocalizationCa extends Localization {
  LocalizationCa([String locale = 'ca']) : super(locale);

  @override
  String get close => 'Tancar';

  @override
  String get error_content =>
      'S\'ha produït un error inesperat. Ja hem registrat aquest error. Torneu-ho a provar més tard.';

  @override
  String get error_oops => 'Vaja, alguna cosa ha anat malament';

  @override
  String get language => 'Idioma del sistema';
}
