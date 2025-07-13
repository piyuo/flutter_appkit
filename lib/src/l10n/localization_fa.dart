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
      'یک خطای غیرمنتظره رخ داد. ما قبلاً این خطا را ثبت کرده‌ایم. لطفاً بعداً دوباره تلاش کنید.';

  @override
  String get error_oops => 'اوه، مشکلی پیش آمد';

  @override
  String get language => 'زبان سیستم';
}
