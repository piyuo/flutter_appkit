// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Galician (`gl`).
class LocalizationGl extends Localization {
  LocalizationGl([String locale = 'gl']) : super(locale);

  @override
  String get close => 'Pechar';

  @override
  String get error_content =>
      'Ocorreu un erro inesperado. Xa rexistramos este erro. Téntao de novo máis tarde.';

  @override
  String get error_oops => 'Vaia, algo saíu mal';

  @override
  String get language => 'Idioma do sistema';
}
