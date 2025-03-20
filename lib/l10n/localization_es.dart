// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LocalizationEs extends Localization {
  LocalizationEs([String locale = 'es']) : super(locale);

  @override
  String get cli_error_oops => 'Ups, algo salió mal';

  @override
  String get cli_error_content => 'Ocurrió un error inesperado. ¿Te gustaría enviar un informe por correo electrónico?';

  @override
  String get cli_error_report => 'Envíanos un correo';

  @override
  String get submit => 'Enviar';

  @override
  String get ok => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Atrás';
}

/// The translations for Spanish Castilian, as used in Argentina (`es_AR`).
class LocalizationEsAr extends LocalizationEs {
  LocalizationEsAr(): super('es_AR');

  @override
  String get cli_error_oops => 'Ups, algo salió mal';

  @override
  String get cli_error_content => 'Ocurrió un error inesperado. ¿Querés enviar un informe por correo electrónico?';

  @override
  String get cli_error_report => 'Envianos un correo';

  @override
  String get submit => 'Enviar';

  @override
  String get ok => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Atrás';
}

/// The translations for Spanish Castilian, as used in Colombia (`es_CO`).
class LocalizationEsCo extends LocalizationEs {
  LocalizationEsCo(): super('es_CO');

  @override
  String get cli_error_oops => 'Ups, algo salió mal';

  @override
  String get cli_error_content => 'Ocurrió un error inesperado. ¿Te gustaría enviar un informe por correo electrónico?';

  @override
  String get cli_error_report => 'Envíanos un correo';

  @override
  String get submit => 'Enviar';

  @override
  String get ok => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Atrás';
}

/// The translations for Spanish Castilian, as used in Mexico (`es_MX`).
class LocalizationEsMx extends LocalizationEs {
  LocalizationEsMx(): super('es_MX');

  @override
  String get cli_error_oops => 'Ups, algo salió mal';

  @override
  String get cli_error_content => 'Ocurrió un error inesperado. ¿Te gustaría enviar un reporte por correo electrónico?';

  @override
  String get cli_error_report => 'Envíanos un correo';

  @override
  String get submit => 'Enviar';

  @override
  String get ok => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Atrás';
}
