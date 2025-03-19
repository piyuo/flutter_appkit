// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class LocalizationZh extends Localization {
  LocalizationZh([String locale = 'zh']) : super(locale);

  @override
  String get cli_error_oops => '糟糕，出了點問題';

  @override
  String get cli_error_content => '發生了意外錯誤。您要提交電子郵件報告嗎？';

  @override
  String get cli_error_report => '寄信給我們';

  @override
  String get submit => '提交';

  @override
  String get ok => '確定';

  @override
  String get cancel => '取消';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get close => '關閉';

  @override
  String get back => '返回';
}
