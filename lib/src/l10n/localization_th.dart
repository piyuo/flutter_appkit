// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class LocalizationTh extends Localization {
  LocalizationTh([String locale = 'th']) : super(locale);

  @override
  String get close => 'ปิด';

  @override
  String get error_content =>
      'เกิดข้อผิดพลาดที่ไม่คาดคิด คุณสามารถส่งรายงานให้เราเพื่อช่วยให้เราปรับปรุง หรือลองใหม่อีกครั้งในภายหลัง';

  @override
  String get error_oops => 'อุปส์ มีบางอย่างผิดพลาด';

  @override
  String get error_report_anonymously =>
      'ช่วยให้เราปรับปรุงโดยส่งรายงานแบบไม่ระบุตัวตน';

  @override
  String get language => 'ภาษาระบบ';
}
