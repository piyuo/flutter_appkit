// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class LocalizationZh extends Localization {
  LocalizationZh([String locale = 'zh']) : super(locale);

  @override
  String get back => '返回';

  @override
  String get cancel => '取消';

  @override
  String get close => '關閉';

  @override
  String get managed_error_content => '發生了意外錯誤。我們已經記錄了這個錯誤。請稍後再試。';

  @override
  String get managed_error_oops => '糟糕，出了點問題';

  @override
  String get no => '否';

  @override
  String get ok => '確定';

  @override
  String get submit => '提交';

  @override
  String get system_language => '系統語言';

  @override
  String get yes => '是';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class LocalizationZhCn extends LocalizationZh {
  LocalizationZhCn() : super('zh_CN');

  @override
  String get back => '返回';

  @override
  String get cancel => '取消';

  @override
  String get close => '关闭';

  @override
  String get managed_error_content => '发生了意外错误。我们已经记录了这个错误。请稍后重试。';

  @override
  String get managed_error_oops => '糟糕，出错了';

  @override
  String get no => '否';

  @override
  String get ok => '确定';

  @override
  String get submit => '提交';

  @override
  String get system_language => '系统语言';

  @override
  String get yes => '是';
}

/// The translations for Chinese, as used in Hong Kong (`zh_HK`).
class LocalizationZhHk extends LocalizationZh {
  LocalizationZhHk() : super('zh_HK');

  @override
  String get back => '返回';

  @override
  String get cancel => '取消';

  @override
  String get close => '關閉';

  @override
  String get managed_error_content => '發生了意外錯誤。我們已經記錄了這個錯誤。請稍後再試。';

  @override
  String get managed_error_oops => '哎呀，出錯了';

  @override
  String get no => '否';

  @override
  String get ok => '確定';

  @override
  String get submit => '提交';

  @override
  String get system_language => '系統語言';

  @override
  String get yes => '是';
}

/// The translations for Chinese, as used in Macao (`zh_MO`).
class LocalizationZhMo extends LocalizationZh {
  LocalizationZhMo() : super('zh_MO');

  @override
  String get back => '返回';

  @override
  String get cancel => '取消';

  @override
  String get close => '關閉';

  @override
  String get managed_error_content => '發生了意外錯誤。我們已經記錄了這個錯誤。請稍後再試。';

  @override
  String get managed_error_oops => '哎呀，出錯了';

  @override
  String get no => '否';

  @override
  String get ok => '確定';

  @override
  String get submit => '提交';

  @override
  String get system_language => '系統語言';

  @override
  String get yes => '是';
}

/// The translations for Chinese, as used in Singapore (`zh_SG`).
class LocalizationZhSg extends LocalizationZh {
  LocalizationZhSg() : super('zh_SG');

  @override
  String get back => '返回';

  @override
  String get cancel => '取消';

  @override
  String get close => '关闭';

  @override
  String get managed_error_content => '发生了意外错误。我们已经记录了这个错误。请稍后重试。';

  @override
  String get managed_error_oops => '哎呀，出错了';

  @override
  String get no => '否';

  @override
  String get ok => '确定';

  @override
  String get submit => '提交';

  @override
  String get system_language => '系統語言';

  @override
  String get yes => '是';
}
