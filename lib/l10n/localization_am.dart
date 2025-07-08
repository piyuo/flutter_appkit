// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class LocalizationAm extends Localization {
  LocalizationAm([String locale = 'am']) : super(locale);

  @override
  String get back => 'ተመለስ';

  @override
  String get cancel => 'ሰርዝ';

  @override
  String get close => 'ዝጋ';

  @override
  String get managed_error_content =>
      'የማይጠበቅ ስህተት ተከስቷል። ይህን ስህተት አስቀድመን ሰፍረናል። እባክዎ ቆይተው ዳግመኛ ይሞክሩ።';

  @override
  String get managed_error_oops => 'ይቅርታ፣ የሆነ ስህተት ተከስቷል';

  @override
  String get no => 'አይ';

  @override
  String get ok => 'እሺ';

  @override
  String get submit => 'አስገባ';

  @override
  String get system_language => 'የስርዓት ቋንቋ';

  @override
  String get yes => 'አዎ';
}
