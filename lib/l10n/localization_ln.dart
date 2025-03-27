// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Lingala (`ln`).
class LocalizationLn extends Localization {
  LocalizationLn([String locale = 'ln']) : super(locale);

  @override
  String get cli_error_oops => 'Oyo, eloko moko esalemi malamu te';

  @override
  String get cli_error_content => 'Mbeba oyo toyebaki te esalemi. Olingi kotinda rapport na email?';

  @override
  String get cli_error_report => 'Tindela biso email';

  @override
  String get submit => 'Tinda';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get yes => 'Iyo';

  @override
  String get no => 'Te';

  @override
  String get close => 'Kanga';

  @override
  String get back => 'Zonga';

  @override
  String get system_language => 'Ya Mpate';
}
