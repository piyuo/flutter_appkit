// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class LocalizationUr extends Localization {
  LocalizationUr([String locale = 'ur']) : super(locale);

  @override
  String get close => 'بند کریں';

  @override
  String get error_content =>
      'ایک غیر متوقع خرابی پیش آئی۔ آپ ہمیں بہتر بنانے میں مدد کے لیے رپورٹ بھیج سکتے ہیں، یا بعد میں دوبارہ کوشش کریں۔';

  @override
  String get error_oops => 'افسوس، کچھ غلط ہو گیا';

  @override
  String get error_report_anonymously =>
      'گمنام رپورٹ بھیج کر ہمیں بہتر بنانے میں مدد کریں';

  @override
  String get language => 'نظام کی زبان';
}

/// The translations for Urdu, as used in India (`ur_IN`).
class LocalizationUrIn extends LocalizationUr {
  LocalizationUrIn() : super('ur_IN');

  @override
  String get close => 'بند کریں';

  @override
  String get error_content =>
      'ایک غیر متوقع خرابی پیش آئی۔ آپ ہمیں بہتر بنانے میں مدد کے لیے رپورٹ بھیج سکتے ہیں، یا بعد میں دوبارہ کوشش کریں۔';

  @override
  String get error_oops => 'افسوس، کچھ غلط ہو گیا';

  @override
  String get error_report_anonymously =>
      'گمنام رپورٹ بھیج کر ہمیں بہتر بنانے میں مدد کریں';

  @override
  String get language => 'نظام کی زبان';
}
