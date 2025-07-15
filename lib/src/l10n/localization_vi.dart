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
      'Đã xảy ra lỗi không mong muốn. Bạn có thể gửi cho chúng tôi báo cáo để giúp chúng tôi cải thiện, hoặc thử lại sau.';

  @override
  String get error_oops => 'Rất tiếc, đã xảy ra lỗi';

  @override
  String get error_report_anonymously =>
      'Giúp chúng tôi cải thiện bằng cách gửi báo cáo ẩn danh';

  @override
  String get language => 'Ngôn ngữ hệ thống';
}
