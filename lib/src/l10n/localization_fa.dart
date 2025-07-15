// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class LocalizationFa extends Localization {
  LocalizationFa([String locale = 'fa']) : super(locale);

  @override
  String get close => 'بستن';

  @override
  String get error_content =>
      'یک خطای غیرمنتظره رخ داد. می‌توانید گزارشی برای ما ارسال کنید تا به بهبود ما کمک کنید، یا بعداً دوباره تلاش کنید.';

  @override
  String get error_oops => 'اوه، مشکلی پیش آمد';

  @override
  String get error_report_anonymously =>
      'با ارسال گزارش ناشناس به بهبود ما کمک کنید';

  @override
  String get language => 'زبان سیستم';
}
