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
      'Ocorreu un erro inesperado. Podes enviarnos un informe para axudarnos a mellorar, ou téntao de novo máis tarde.';

  @override
  String get error_oops => 'Vaia, algo saíu mal';

  @override
  String get error_report_anonymously =>
      'Axúdanos a mellorar enviando un informe anónimo';

  @override
  String get language => 'Idioma do sistema';
}
