// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class LocalizationMr extends Localization {
  LocalizationMr([String locale = 'mr']) : super(locale);

  @override
  String get back => 'मागे';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get close => 'बंद करा';

  @override
  String get managed_error_content =>
      'अनपेक्षित त्रुटी आली. आम्ही आधीच ही त्रुटी लॉग केली आहे. कृपया नंतर पुन्हा प्रयत्न करा.';

  @override
  String get managed_error_oops => 'अरेरे, काहीतरी चूक झाली';

  @override
  String get no => 'नाही';

  @override
  String get ok => 'ठीक आहे';

  @override
  String get submit => 'सबमिट करा';

  @override
  String get system_language => 'प्रणाली भाषा';

  @override
  String get yes => 'होय';
}
