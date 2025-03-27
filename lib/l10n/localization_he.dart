// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class LocalizationHe extends Localization {
  LocalizationHe([String locale = 'he']) : super(locale);

  @override
  String get cli_error_oops => 'אופס, משהו השתבש';

  @override
  String get cli_error_content => 'אירעה שגיאה בלתי צפויה. האם תרצה לשלוח דוח באימייל?';

  @override
  String get cli_error_report => 'שלח לנו אימייל';

  @override
  String get submit => 'שלח';

  @override
  String get ok => 'אישור';

  @override
  String get cancel => 'ביטול';

  @override
  String get yes => 'כן';

  @override
  String get no => 'לא';

  @override
  String get close => 'סגור';

  @override
  String get back => 'חזרה';

  @override
  String get system_language => 'שפת מערכת';
}
