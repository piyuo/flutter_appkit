// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Kurdish (`ku`).
class LocalizationKu extends Localization {
  LocalizationKu([String locale = 'ku']) : super(locale);

  @override
  String get cli_error_oops => 'Ops, tiştek çewt çû';

  @override
  String get cli_error_content => 'Çewtiyeke nenas derket. Ma hûn dixwazin raporeke e-mailê bişînin?';

  @override
  String get cli_error_report => 'Ji me re e-mail bişînin';

  @override
  String get submit => 'Bişîne';

  @override
  String get ok => 'Baş e';

  @override
  String get cancel => 'Betal bike';

  @override
  String get yes => 'Erê';

  @override
  String get no => 'Na';

  @override
  String get close => 'Bigire';

  @override
  String get back => 'Vegere';

  @override
  String get system_language => 'Zmmana ya Mpate';
}
