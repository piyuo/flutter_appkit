// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class LocalizationAm extends Localization {
  LocalizationAm([String locale = 'am']) : super(locale);

  @override
  String get close => 'ዝጋ';

  @override
  String get error_content =>
      'የማይጠበቅ ስህተት ተከስቷል። ለመሻሻል እንድንችል ሪፖርት ልትልክልን ትችላለህ፣ ወይም ደግሞ ቆይተህ ዳግመኛ ሞክር።';

  @override
  String get error_oops => 'ይቅርታ፣ የሆነ ስህተት ተከስቷል';

  @override
  String get error_report_anonymously => 'ለማሻሻል እንድንችል ስም አልባ ሪፖርት በመላክ ያግዙን';

  @override
  String get language => 'የስርዓት ቋንቋ';
}
