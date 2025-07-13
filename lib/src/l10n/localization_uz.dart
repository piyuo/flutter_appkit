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
      'Kutilmagan xatolik yuz berdi. Biz bu xatolikni allaqachon yozib qo\'ygamiz. Iltimos keyinroq qayta urinib ko\'ring.';

  @override
  String get error_oops => 'Voy, xatolik yuz berdi';

  @override
  String get language => 'Tizim tili';
}
