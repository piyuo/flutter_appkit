// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Mongolian (`mn`).
class LocalizationMn extends Localization {
  LocalizationMn([String locale = 'mn']) : super(locale);

  @override
  String get back => 'Буцах';

  @override
  String get cancel => 'Цуцлах';

  @override
  String get close => 'Хаах';

  @override
  String get managed_error_content =>
      'Гэнэтийн алдаа гарлаа. Бид энэ алдааг аль хэдийн бүртгэсэн. Дараа дахин оролдоно уу.';

  @override
  String get managed_error_oops => 'Өө, ямар нэгэн зүйл буруу болсон';

  @override
  String get no => 'Үгүй';

  @override
  String get ok => 'ЗА';

  @override
  String get submit => 'Илгээх';

  @override
  String get system_language => 'Системийн хэл';

  @override
  String get yes => 'Тийм';
}
