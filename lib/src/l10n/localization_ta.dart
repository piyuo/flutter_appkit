// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class LocalizationTa extends Localization {
  LocalizationTa([String locale = 'ta']) : super(locale);

  @override
  String get close => 'மூடு';

  @override
  String get error_content =>
      'எதிர்பாராத பிழை ஏற்பட்டது. இந்தப் பிழையை நாங்கள் ஏற்கனவே பதிவு செய்துள்ளோம். தயவுசெய்து பின்னர் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get error_oops => 'அடடா, ஏதோ தவறு நடந்துவிட்டது';

  @override
  String get language => 'கணினி மொழி';
}
