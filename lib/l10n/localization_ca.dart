// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class LocalizationCa extends Localization {
  LocalizationCa([String locale = 'ca']) : super(locale);

  @override
  String get cli_error_oops => 'Vaja, alguna cosa ha anat malament';

  @override
  String get cli_error_content => 'S\'ha produït un error inesperat. Vols enviar un informe per correu electrònic?';

  @override
  String get cli_error_report => 'Envia\'ns un correu';

  @override
  String get submit => 'Enviar';

  @override
  String get ok => 'D\'acord';

  @override
  String get cancel => 'Cancel·lar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get close => 'Tancar';

  @override
  String get back => 'Enrere';

  @override
  String get system_language => 'Idioma del sistema';
}
