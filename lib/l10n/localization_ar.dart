// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class LocalizationAr extends Localization {
  LocalizationAr([String locale = 'ar']) : super(locale);

  @override
  String get cli_error_oops => 'عفواً، حدث خطأ ما';

  @override
  String get cli_error_content => 'حدث خطأ غير متوقع. هل ترغب في إرسال تقرير بالبريد الإلكتروني؟';

  @override
  String get cli_error_report => 'راسلنا';

  @override
  String get submit => 'إرسال';

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';
}

/// The translations for Arabic, as used in the United Arab Emirates (`ar_AE`).
class LocalizationArAe extends LocalizationAr {
  LocalizationArAe(): super('ar_AE');

  @override
  String get cli_error_oops => 'عفواً، حدث خطأ ما';

  @override
  String get cli_error_content => 'حدث خطأ غير متوقع. هل ترغب في إرسال تقرير بالبريد الإلكتروني؟';

  @override
  String get cli_error_report => 'راسلنا عبر البريد الإلكتروني';

  @override
  String get submit => 'إرسال';

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';
}

/// The translations for Arabic, as used in Algeria (`ar_DZ`).
class LocalizationArDz extends LocalizationAr {
  LocalizationArDz(): super('ar_DZ');

  @override
  String get cli_error_oops => 'عفواً، حدث خطأ ما';

  @override
  String get cli_error_content => 'حدث خطأ غير متوقع. هل ترغب في إرسال تقرير بالبريد الإلكتروني؟';

  @override
  String get cli_error_report => 'راسلنا عبر البريد الإلكتروني';

  @override
  String get submit => 'إرسال';

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';
}

/// The translations for Arabic, as used in Egypt (`ar_EG`).
class LocalizationArEg extends LocalizationAr {
  LocalizationArEg(): super('ar_EG');

  @override
  String get cli_error_oops => 'عفواً، حدث خطأ ما';

  @override
  String get cli_error_content => 'حدث خطأ غير متوقع. هل ترغب في إرسال تقرير بالبريد الإلكتروني؟';

  @override
  String get cli_error_report => 'راسلنا بالبريد الإلكتروني';

  @override
  String get submit => 'إرسال';

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';
}
