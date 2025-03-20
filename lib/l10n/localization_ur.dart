// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class LocalizationUr extends Localization {
  LocalizationUr([String locale = 'ur']) : super(locale);

  @override
  String get cli_error_oops => 'افسوس، کچھ غلط ہو گیا';

  @override
  String get cli_error_content => 'ایک غیر متوقع خرابی پیش آئی۔ کیا آپ ای میل رپورٹ جمع کرانا چاہتے ہیں؟';

  @override
  String get cli_error_report => 'ہمیں ای میل کریں';

  @override
  String get submit => 'جمع کرائیں';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get yes => 'ہاں';

  @override
  String get no => 'نہیں';

  @override
  String get close => 'بند کریں';

  @override
  String get back => 'واپس';
}

/// The translations for Urdu, as used in India (`ur_IN`).
class LocalizationUrIn extends LocalizationUr {
  LocalizationUrIn(): super('ur_IN');

  @override
  String get cli_error_oops => 'افسوس، کچھ غلط ہو گیا';

  @override
  String get cli_error_content => 'ایک غیر متوقع خرابی پیش آئی۔ کیا آپ ای میل رپورٹ جمع کرانا چاہتے ہیں؟';

  @override
  String get cli_error_report => 'ہمیں ای میل کریں';

  @override
  String get submit => 'جمع کرائیں';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get yes => 'ہاں';

  @override
  String get no => 'نہیں';

  @override
  String get close => 'بند کریں';

  @override
  String get back => 'واپس';
}
