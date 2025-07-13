// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class LocalizationVi extends Localization {
  LocalizationVi([String locale = 'vi']) : super(locale);

  @override
  String get close => 'Đóng';

  @override
  String get error_content =>
      'Đã xảy ra lỗi không mong muốn. Chúng tôi đã ghi lại lỗi này rồi. Vui lòng thử lại sau.';

  @override
  String get error_oops => 'Rất tiếc, đã xảy ra lỗi';

  @override
  String get language => 'Ngôn ngữ hệ thống';
}
