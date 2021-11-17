


import 'app_localizations.dart';

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get retry => '重试';

  @override
  String get ok => '确定';

  @override
  String get cancel => '取消';

  @override
  String get close => '关闭';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get create => '新增';

  @override
  String get delete => '删除';

  @override
  String get save => '存档';

  @override
  String get back => '返回';

  @override
  String get hello => '您好';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw(): super('zh_TW');

  @override
  String get retry => '重試';

  @override
  String get ok => '確定';

  @override
  String get cancel => '取消';

  @override
  String get close => '關閉';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get create => '新增';

  @override
  String get delete => '刪除';

  @override
  String get save => '存檔';

  @override
  String get back => '返回';

  @override
  String get hello => '您好';
}
