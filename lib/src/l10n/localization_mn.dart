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
      'Гэнэтийн алдаа гарлаа. Та бидэнд сайжруулахад туслахын тулд тайлан илгээж болно, эсвэл дараа дахин оролдоно уу.';

  @override
  String get error_oops => 'Өө, ямар нэгэн зүйл буруу болсон';

  @override
  String get error_report_anonymously =>
      'Нэрээ нууцалсан тайлан илгээж сайжруулахад тусалаарай';

  @override
  String get language => 'Системийн хэл';
}
