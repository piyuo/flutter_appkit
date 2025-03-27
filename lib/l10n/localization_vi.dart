// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class LocalizationVi extends Localization {
  LocalizationVi([String locale = 'vi']) : super(locale);

  @override
  String get cli_error_oops => 'Rất tiếc, đã xảy ra lỗi';

  @override
  String get cli_error_content => 'Đã xảy ra lỗi không mong muốn. Bạn có muốn gửi báo cáo qua email không?';

  @override
  String get cli_error_report => 'Gửi email cho chúng tôi';

  @override
  String get submit => 'Gửi đi';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Hủy';

  @override
  String get yes => 'Có';

  @override
  String get no => 'Không';

  @override
  String get close => 'Đóng';

  @override
  String get back => 'Quay lại';

  @override
  String get system_language => 'Ngôn ngữ hệ thống';
}
