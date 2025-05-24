// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class LocalizationFa extends Localization {
  LocalizationFa([String locale = 'fa']) : super(locale);

  @override
  String get cli_error_oops => 'اوه، مشکلی پیش آمد';

  @override
  String get cli_error_content =>
      'یک خطای غیرمنتظره رخ داد. آیا می‌خواهید گزارشی از طریق ایمیل ارسال کنید؟';

  @override
  String get cli_error_report => 'به ما ایمیل بزنید';

  @override
  String get submit => 'ارسال';

  @override
  String get ok => 'تایید';

  @override
  String get cancel => 'لغو';

  @override
  String get yes => 'بله';

  @override
  String get no => 'خیر';

  @override
  String get close => 'بستن';

  @override
  String get back => 'بازگشت';

  @override
  String get system_language => 'زبان سیستم';
}
