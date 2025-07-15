// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class LocalizationHi extends Localization {
  LocalizationHi([String locale = 'hi']) : super(locale);

  @override
  String get close => 'बंद करें';

  @override
  String get error_content =>
      'एक अप्रत्याशित त्रुटि हुई। आप हमें बेहतर बनाने में मदद करने के लिए हमें एक रिपोर्ट भेज सकते हैं, या बाद में पुनः प्रयास कर सकते हैं।';

  @override
  String get error_oops => 'उफ़, कुछ गलत हो गया';

  @override
  String get error_report_anonymously =>
      'एक अज्ञात रिपोर्ट भेजकर हमें बेहतर बनाने में मदद करें';

  @override
  String get language => 'सिस्टम भाषा';
}
