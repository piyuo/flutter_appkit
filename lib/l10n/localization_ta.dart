// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class LocalizationTa extends Localization {
  LocalizationTa([String locale = 'ta']) : super(locale);

  @override
  String get cli_error_oops => 'அடடா, ஏதோ தவறு நடந்துவிட்டது';

  @override
  String get cli_error_content => 'எதிர்பாராத பிழை ஏற்பட்டது. மின்னஞ்சல் அறிக்கையை சமர்ப்பிக்க விரும்புகிறீர்களா?';

  @override
  String get cli_error_report => 'எங்களுக்கு மின்னஞ்சல் அனுப்பவும்';

  @override
  String get submit => 'சமர்ப்பி';

  @override
  String get ok => 'சரி';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get yes => 'ஆம்';

  @override
  String get no => 'இல்லை';

  @override
  String get close => 'மூடு';

  @override
  String get back => 'பின்செல்';
}
