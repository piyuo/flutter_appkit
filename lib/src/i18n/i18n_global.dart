import 'package:flutter/foundation.dart';
import 'package:libcli/log.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/i18n/i18n.dart' as i18n;

const _here = 'i18n_global';

/// _global global translation
///
var _global = {};

/// globalTranslate translate from global localization
///
String globalTranslate(String key) {
  var value = _global[key];
  if (value == null) {
    alert('i18n~missing $key in global');
    return '!!! $key not found';
  }
  return value;
}

/// reloadGlobalTranslation load global translation base on locale
///
Future<void> reloadGlobalTranslation(
    String languageCode, String countryCode) async {
  _global.clear();
  switch (i18n.localeID) {
    case 'zh_TW':
      _zh_TW();
      break;
    case 'zh_CN':
      _zh_CN();
      break;
    default:
      _en_US();
      break;
  }
  var j = toString(_global);
  debugPrint('$_here~global localzation = $j');
}
/*
Future<void> reloadGlobalTranslation(
    String languageCode, String countryCode) async {
  String libJson = await asset.loadJson(
      'i18n/$languageCode/$countryCode/global.json',
      package: 'libcli');
  _globalLocalization = json.decode(libJson);
  var j = toString(_globalLocalization);
  debugPrint('$_here~global localzation = $j');
}
*/

void _en_US() {
  _global['errTitle'] = 'Oops, some thing went wrong';
  _global['errMsg'] =
      'The developer team has been notified of this issue. Please try again later';
  _global['emailUs'] = 'Email Us';
  _global['errCode'] = 'Error code: ';
  _global['email'] = 'Email';
  _global['retry'] = 'Retry';
  _global['ok'] = 'Ok';
  _global['cancel'] = 'Cancel';
  _global['close'] = 'Close';
  _global['back'] = 'Back';
  _global['slow'] = 'your network is slow than usual';
  _global['required'] = '%1 is required';
  _global['valid'] = 'Please enter a valid %1.  (Example: %2)';
  _global['emailAdr'] = 'email address';
  _global['domain'] = 'domain name';
  _global['url'] = 'url';
  _global['enterYour'] = 'Enter your %1';
  _global['minLenth'] = '%1 must contain at least %2 character';
}

void _zh_TW() {
  _global['errTitle'] = '糟糕，有東西出錯了';
  _global['errMsg'] = '發生的錯誤已被記錄並且通知了我們的開發團隊，您可以稍後再重試';
  _global['emailUs'] = '發送電子郵件給我們';
  _global['errCode'] = '錯誤代碼: ';
  _global['email'] = '電子郵件';
  _global['retry'] = '重試';
  _global['ok'] = '確定';
  _global['cancel'] = '取消';
  _global['close'] = '關閉';
  _global['back'] = '返回';
  _global['slow'] = '您的網路速度比平時慢';
  _global['required'] = '%1必須填寫';
  _global['validator'] = '請輸入一個有效的%1.  (範例: %2)';
  _global['emailAdr'] = '電子郵件地址';
  _global['domain'] = '域名';
  _global['url'] = '網址';
  _global['enterYour'] = '輸入你的%1';
  _global['minLenth'] = '%1必須至少包含 %2 個字元';
}

void _zh_CN() {
  _global['errTitle'] = '糟了，有东西出错';
  _global['errMsg'] = '发生的错误已被记录并且通知了我们的开发团队，您可以按下方 "重试" 按钮再试一遍';
  _global['email'] = '电子邮件';
  _global['emailUs'] = '發送电子邮件给我们';
  _global['errCode'] = '错误代码: ';
  _global['retry'] = '重试';
  _global['ok'] = '确定';
  _global['cancel'] = '取消';
  _global['close'] = '关闭';
  _global['back'] = '返回';
  _global['slow'] = '您的网路速度比平时慢';
  _global['required'] = '%1必须填写';
  _global['validator'] = '请输入一个有效的%1.  (范例: %2)';
  _global['emailAdr'] = '电子邮件地址';
  _global['domain'] = '域名';
  _global['url'] = '网址';
  _global['enterYour'] = '输入你的%1';
  _global['minLenth'] = '%1必须至少包含 %2 个字元';
}
