// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class LocalizationUz extends Localization {
  LocalizationUz([String locale = 'uz']) : super(locale);

  @override
  String get back => 'Orqaga';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get close => 'Yopish';

  @override
  String get managed_error_content =>
      'Kutilmagan xatolik yuz berdi. Biz bu xatolikni allaqachon yozib qo\'ygamiz. Iltimos keyinroq qayta urinib ko\'ring.';

  @override
  String get managed_error_oops => 'Voy, xatolik yuz berdi';

  @override
  String get no => 'Yo\'q';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Yuborish';

  @override
  String get system_language => 'Tizim tili';

  @override
  String get yes => 'Ha';
}
