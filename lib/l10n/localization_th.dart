// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class LocalizationTh extends Localization {
  LocalizationTh([String locale = 'th']) : super(locale);

  @override
  String get cli_error_oops => 'อุปส์ มีบางอย่างผิดพลาด';

  @override
  String get cli_error_content => 'เกิดข้อผิดพลาดที่ไม่คาดคิด คุณต้องการส่งรายงานทางอีเมลหรือไม่?';

  @override
  String get cli_error_report => 'อีเมลถึงเรา';

  @override
  String get submit => 'ส่ง';

  @override
  String get ok => 'ตกลง';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get yes => 'ใช่';

  @override
  String get no => 'ไม่';

  @override
  String get close => 'ปิด';

  @override
  String get back => 'กลับ';
}
