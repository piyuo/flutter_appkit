// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Galician (`gl`).
class LocalizationGl extends Localization {
  LocalizationGl([String locale = 'gl']) : super(locale);

  @override
  String get cli_error_oops => 'Vaia, algo saíu mal';

  @override
  String get cli_error_content => 'Ocorreu un erro inesperado. Queres enviar un informe por correo electrónico?';

  @override
  String get cli_error_report => 'Envíanos un correo';

  @override
  String get submit => 'Enviar';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Si';

  @override
  String get no => 'Non';

  @override
  String get close => 'Pechar';

  @override
  String get back => 'Atrás';

  @override
  String get system_language => 'Idioma do sistema';
}
