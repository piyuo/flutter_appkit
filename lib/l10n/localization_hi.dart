// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class LocalizationHi extends Localization {
  LocalizationHi([String locale = 'hi']) : super(locale);

  @override
  String get back => 'वापस';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get close => 'बंद करें';

  @override
  String get managed_error_content =>
      'एक अप्रत्याशित त्रुटि हुई। हमने पहले से ही इस त्रुटि को लॉग किया है। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get managed_error_oops => 'उफ़, कुछ गलत हो गया';

  @override
  String get no => 'नहीं';

  @override
  String get ok => 'ठीक है';

  @override
  String get submit => 'सबमिट करें';

  @override
  String get system_language => 'सिस्टम भाषा';

  @override
  String get yes => 'हाँ';
}
