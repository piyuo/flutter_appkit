// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class LocalizationUr extends Localization {
  LocalizationUr([String locale = 'ur']) : super(locale);

  @override
  String get back => 'واپس';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get close => 'بند کریں';

  @override
  String get managed_error_content =>
      'ایک غیر متوقع خرابی پیش آئی۔ ہم نے اس خرابی کو پہلے سے ہی لاگ کر دیا ہے۔ برائے کرم بعد میں دوبارہ کوشش کریں۔';

  @override
  String get managed_error_oops => 'افسوس، کچھ غلط ہو گیا';

  @override
  String get no => 'نہیں';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get submit => 'جمع کرائیں';

  @override
  String get system_language => 'نظام کی زبان';

  @override
  String get yes => 'ہاں';
}

/// The translations for Urdu, as used in India (`ur_IN`).
class LocalizationUrIn extends LocalizationUr {
  LocalizationUrIn() : super('ur_IN');

  @override
  String get back => 'واپس';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get close => 'بند کریں';

  @override
  String get managed_error_content =>
      'ایک غیر متوقع خرابی پیش آئی۔ ہم نے اس خرابی کو پہلے سے ہی لاگ کر دیا ہے۔ برائے کرم بعد میں دوبارہ کوشش کریں۔';

  @override
  String get managed_error_oops => 'افسوس، کچھ غلط ہو گیا';

  @override
  String get no => 'نہیں';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get submit => 'جمع کرائیں';

  @override
  String get system_language => 'نظام کی زبان';

  @override
  String get yes => 'ہاں';
}
