// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class LocalizationUz extends Localization {
  LocalizationUz([String locale = 'uz']) : super(locale);

  @override
  String get cli_error_oops => 'Voy, xatolik yuz berdi';

  @override
  String get cli_error_content => 'Kutilmagan xatolik yuz berdi. Elektron pochta hisobotini yuborishni xohlaysizmi?';

  @override
  String get cli_error_report => 'Bizga elektron pochta yuboring';

  @override
  String get submit => 'Yuborish';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get yes => 'Ha';

  @override
  String get no => 'Yo\'q';

  @override
  String get close => 'Yopish';

  @override
  String get back => 'Orqaga';

  @override
  String get system_language => 'Tizim tili';
}
