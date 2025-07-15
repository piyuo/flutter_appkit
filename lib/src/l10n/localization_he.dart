// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class LocalizationHe extends Localization {
  LocalizationHe([String locale = 'he']) : super(locale);

  @override
  String get close => 'סגור';

  @override
  String get error_content =>
      'אירעה שגיאה בלתי צפויה. אתה יכול לשלוח לנו דוח כדי לעזור לנו להשתפר, או לנסות שוב מאוחר יותר.';

  @override
  String get error_oops => 'אופס, משהו השתבש';

  @override
  String get error_report_anonymously =>
      'עזרו לנו להשתפר על ידי שליחת דוח אנונימי';

  @override
  String get language => 'שפת מערכת';
}
