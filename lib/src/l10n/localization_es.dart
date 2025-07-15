// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LocalizationEs extends Localization {
  LocalizationEs([String locale = 'es']) : super(locale);

  @override
  String get close => 'Cerrar';

  @override
  String get error_content =>
      'Ocurrió un error inesperado. Puedes enviarnos un informe para ayudarnos a mejorar, o inténtalo de nuevo más tarde.';

  @override
  String get error_oops => 'Ups, algo salió mal';

  @override
  String get error_report_anonymously =>
      'Ayúdanos a mejorar enviando un informe anónimo';

  @override
  String get language => 'Idioma del sistema';
}

/// The translations for Spanish Castilian, as used in Argentina (`es_AR`).
class LocalizationEsAr extends LocalizationEs {
  LocalizationEsAr() : super('es_AR');

  @override
  String get close => 'Cerrar';

  @override
  String get error_content =>
      'Ocurrió un error inesperado. Podés enviarnos un reporte para ayudarnos a mejorar, o intentá de nuevo más tarde.';

  @override
  String get error_oops => 'Ups, algo salió mal';

  @override
  String get error_report_anonymously =>
      'Ayudanos a mejorar enviando un reporte anónimo';

  @override
  String get language => 'Idioma del sistema';
}

/// The translations for Spanish Castilian, as used in Colombia (`es_CO`).
class LocalizationEsCo extends LocalizationEs {
  LocalizationEsCo() : super('es_CO');

  @override
  String get close => 'Cerrar';

  @override
  String get error_content =>
      'Ocurrió un error inesperado. Puedes enviarnos un informe para ayudarnos a mejorar, o inténtalo de nuevo más tarde.';

  @override
  String get error_oops => 'Ups, algo salió mal';

  @override
  String get error_report_anonymously =>
      'Ayúdanos a mejorar enviando un informe anónimo';

  @override
  String get language => 'Idioma del sistema';
}

/// The translations for Spanish Castilian, as used in Mexico (`es_MX`).
class LocalizationEsMx extends LocalizationEs {
  LocalizationEsMx() : super('es_MX');

  @override
  String get close => 'Cerrar';

  @override
  String get error_content =>
      'Ocurrió un error inesperado. Puedes enviarnos un reporte para ayudarnos a mejorar, o inténtalo de nuevo más tarde.';

  @override
  String get error_oops => 'Ups, algo salió mal';

  @override
  String get error_report_anonymously =>
      'Ayúdanos a mejorar enviando un reporte anónimo';

  @override
  String get language => 'Idioma del sistema';
}
