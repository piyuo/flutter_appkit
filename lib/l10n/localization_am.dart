// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class LocalizationAm extends Localization {
  LocalizationAm([String locale = 'am']) : super(locale);

  @override
  String get cli_error_oops => 'ይቅርታ፣ የሆነ ስህተት ተከስቷል';

  @override
  String get cli_error_content => 'የማይጠበቅ ስህተት ተከስቷል። የኢሜይል ሪፖርት ማስገባት ይፈልጋሉ?';

  @override
  String get cli_error_report => 'ኢሜይል ይላኩልን';

  @override
  String get submit => 'አስገባ';

  @override
  String get ok => 'እሺ';

  @override
  String get cancel => 'ሰርዝ';

  @override
  String get yes => 'አዎ';

  @override
  String get no => 'አይ';

  @override
  String get close => 'ዝጋ';

  @override
  String get back => 'ተመለስ';

  @override
  String get system_language => 'የስርዓት ቋንቋ';
}
