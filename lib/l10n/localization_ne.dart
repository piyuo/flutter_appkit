// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class LocalizationNe extends Localization {
  LocalizationNe([String locale = 'ne']) : super(locale);

  @override
  String get cli_error_oops => 'उफ्, केही गलत भयो';

  @override
  String get cli_error_content => 'अनपेक्षित त्रुटि भयो। के तपाईं इमेल रिपोर्ट पठाउन चाहनुहुन्छ?';

  @override
  String get cli_error_report => 'हामीलाई इमेल गर्नुहोस्';

  @override
  String get submit => 'पेश गर्नुहोस्';

  @override
  String get ok => 'ठिक छ';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get yes => 'हो';

  @override
  String get no => 'होइन';

  @override
  String get close => 'बन्द गर्नुहोस्';

  @override
  String get back => 'पछाडि';
}
