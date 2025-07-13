// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Mongolian (`mn`).
class LocalizationMn extends Localization {
  LocalizationMn([String locale = 'mn']) : super(locale);

  @override
  String get close => 'Хаах';

  @override
  String get error_content =>
      'Гэнэтийн алдаа гарлаа. Бид энэ алдааг аль хэдийн бүртгэсэн. Дараа дахин оролдоно уу.';

  @override
  String get error_oops => 'Өө, ямар нэгэн зүйл буруу болсон';

  @override
  String get language => 'Системийн хэл';
}
