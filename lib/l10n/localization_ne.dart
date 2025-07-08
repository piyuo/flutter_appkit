// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class LocalizationNe extends Localization {
  LocalizationNe([String locale = 'ne']) : super(locale);

  @override
  String get back => 'पछाडि';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get close => 'बन्द गर्नुहोस्';

  @override
  String get managed_error_content =>
      'अनपेक्षित त्रुटि भयो। हामीले यो त्रुटि पहिले नै लग गरिसकेका छौं। कृपया पछि फेरि प्रयास गर्नुहोस्।';

  @override
  String get managed_error_oops => 'उफ्, केही गलत भयो';

  @override
  String get no => 'होइन';

  @override
  String get ok => 'ठिक छ';

  @override
  String get submit => 'पेश गर्नुहोस्';

  @override
  String get system_language => 'प्रणाली भाषा';

  @override
  String get yes => 'हो';
}
