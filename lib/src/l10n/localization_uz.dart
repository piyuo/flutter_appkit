// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class LocalizationUz extends Localization {
  LocalizationUz([String locale = 'uz']) : super(locale);

  @override
  String get close => 'Yopish';

  @override
  String get error_content =>
      'Kutilmagan xatolik yuz berdi. Bizni yaxshilashga yordam berish uchun bizga hisobot yuborishingiz mumkin, yoki keyinroq qayta urinib ko\'ring.';

  @override
  String get error_oops => 'Voy, xatolik yuz berdi';

  @override
  String get error_report_anonymously =>
      'Anonim hisobot yuborish orqali yaxshilashimizga yordam bering';

  @override
  String get language => 'Tizim tili';
}
