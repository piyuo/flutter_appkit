// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class LocalizationHe extends Localization {
  LocalizationHe([String locale = 'he']) : super(locale);

  @override
  String get back => 'חזרה';

  @override
  String get cancel => 'ביטול';

  @override
  String get close => 'סגור';

  @override
  String get managed_error_content =>
      'אירעה שגיאה בלתי צפויה. כבר רשמנו את השגיאה הזו. אנא נסה שוב מאוחר יותר.';

  @override
  String get managed_error_oops => 'אופס, משהו השתבש';

  @override
  String get no => 'לא';

  @override
  String get ok => 'אישור';

  @override
  String get submit => 'שלח';

  @override
  String get system_language => 'שפת מערכת';

  @override
  String get yes => 'כן';
}
