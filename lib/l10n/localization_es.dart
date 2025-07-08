// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LocalizationEs extends Localization {
  LocalizationEs([String locale = 'es']) : super(locale);

  @override
  String get back => 'Atrás';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get managed_error_content =>
      'Ocurrió un error inesperado. Ya hemos registrado este error. Por favor, inténtalo de nuevo más tarde.';

  @override
  String get managed_error_oops => 'Ups, algo salió mal';

  @override
  String get no => 'No';

  @override
  String get ok => 'Aceptar';

  @override
  String get submit => 'Enviar';

  @override
  String get system_language => 'Idioma del sistema';

  @override
  String get yes => 'Sí';
}

/// The translations for Spanish Castilian, as used in Argentina (`es_AR`).
class LocalizationEsAr extends LocalizationEs {
  LocalizationEsAr() : super('es_AR');

  @override
  String get back => 'Atrás';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get managed_error_content =>
      'Ocurrió un error inesperado. Ya registramos este error. Por favor, intentá de nuevo más tarde.';

  @override
  String get managed_error_oops => 'Ups, algo salió mal';

  @override
  String get no => 'No';

  @override
  String get ok => 'Aceptar';

  @override
  String get submit => 'Enviar';

  @override
  String get system_language => 'Idioma del sistema';

  @override
  String get yes => 'Sí';
}

/// The translations for Spanish Castilian, as used in Colombia (`es_CO`).
class LocalizationEsCo extends LocalizationEs {
  LocalizationEsCo() : super('es_CO');

  @override
  String get back => 'Atrás';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get managed_error_content =>
      'Ocurrió un error inesperado. Ya hemos registrado este error. Por favor, inténtalo de nuevo más tarde.';

  @override
  String get managed_error_oops => 'Ups, algo salió mal';

  @override
  String get no => 'No';

  @override
  String get ok => 'Aceptar';

  @override
  String get submit => 'Enviar';

  @override
  String get system_language => 'Idioma del sistema';

  @override
  String get yes => 'Sí';
}

/// The translations for Spanish Castilian, as used in Mexico (`es_MX`).
class LocalizationEsMx extends LocalizationEs {
  LocalizationEsMx() : super('es_MX');

  @override
  String get back => 'Atrás';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get managed_error_content =>
      'Ocurrió un error inesperado. Ya registramos este error. Por favor, inténtalo de nuevo más tarde.';

  @override
  String get managed_error_oops => 'Ups, algo salió mal';

  @override
  String get no => 'No';

  @override
  String get ok => 'Aceptar';

  @override
  String get submit => 'Enviar';

  @override
  String get system_language => 'Idioma del sistema';

  @override
  String get yes => 'Sí';
}
