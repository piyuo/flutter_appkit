// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class LocalizationHi extends Localization {
  LocalizationHi([String locale = 'hi']) : super(locale);

  @override
  String get cli_error_oops => 'उफ़, कुछ गलत हो गया';

  @override
  String get cli_error_content => 'एक अप्रत्याशित त्रुटि हुई। क्या आप ईमेल रिपोर्ट भेजना चाहते हैं?';

  @override
  String get cli_error_report => 'हमें ईमेल करें';

  @override
  String get submit => 'सबमिट करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get close => 'बंद करें';

  @override
  String get back => 'वापस';
}
