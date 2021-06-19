import 'package:libcli/log.dart' as log;
import 'package:libcli/src/i18n/i18n.dart';

/// globalTranslate translate from global localization
///
String globalTranslate(String key) {
  var value = getCurrentGlobalTranslation()[key];
  if (value == null) {
    log.log('${log.COLOR_ALERT}missing $key in i18n global');
    return '!!! $key not found';
  }
  return value;
}

/// getCurrentGlobalTranslation return global translation base on current locale
///
Map getCurrentGlobalTranslation() {
  switch (currentLocaleID) {
    case zh_TW:
      return _zh_TW();
    case zh_CN:
      return _zh_CN();
  }
  return _en_US();
}

Map _en_US() {
  var tryAgain = ', Please try again later';
  return {
    'errTitle': 'Oops, something went wrong',
    'notified': 'The developer team has been notified of this issue${tryAgain}',
    'error': 'Error',
    'emailUs': 'Send email to support team',
    'email': 'Email',
    'retry': 'Retry',
    'ok': 'OK',
    'cancel': 'Cancel',
    'close': 'Close',
    'yes': 'Yes',
    'no': 'No',
    'delete': 'Delete',
    'save': 'Save',
    'back': 'Back',
    'slow': 'your network is slow than usual',
    'required': '%1 is required',
    'valid': 'Please enter a valid %1.  (Example: %2)',
    'emailAdr': 'email address',
    'domain': 'domain name',
    'url': 'url',
    'youMean': 'Did you mean: ',
    'enterYour': 'Enter your %1',
    'minLength': '%1 must contain at least %2 character. You entered %3 characters',
    'maxLength': '%1 must be %2 characters or fewer. You entered %3 characters',
    'noService': 'Service Unavailable',
    'noServiceDesc': 'This service isn\'t available right now${tryAgain}',
    'noInternet': 'No internet!',
    'noInternetDesc': 'Poor network connection detected, Please check your connectivity',
    'blocked': 'Internet blocked!',
    'blockedDesc': 'Our service is blocked by your Firewall or antivirus software',
    'diskError': 'Write failed!',
    'diskErrorDesc': 'Insufficient disk space or write access denied',
    'timeout': 'Operation timed out!',
    'timeoutDesc': 'Your operation didn\'t complete in time${tryAgain}',
    'firewallBlock': 'Too many attempts${tryAgain}',
  };
}

Map _zh_TW() {
  var tryAgain = '，請稍後再試';
  return {
    'errTitle': '糟糕，有東西出錯了',
    'notified': '發生的錯誤已被記錄並且通知了我們的開發團隊${tryAgain}',
    'error': '錯誤',
    'emailUs': '發送電子郵件給我們',
    'errCode': '錯誤代碼: ',
    'email': '電子郵件',
    'retry': '重試',
    'ok': '確定',
    'cancel': '取消',
    'close': '關閉',
    'yes': '是',
    'no': '否',
    'delete': '刪除',
    'save': '存檔',
    'back': '返回',
    'slow': '您的網路速度比平時慢',
    'required': '%1必須填寫',
    'validator': '請輸入一個有效的%1.  (範例: %2)',
    'emailAdr': '電子郵件地址',
    'domain': '域名',
    'url': '網址',
    'youMean': '您想輸入的是: ',
    'enterYour': '輸入你的%1',
    'minLength': '%1必須至少包含 %2 個字元. 你輸入了 %3 個字元',
    'maxLength': '%1必須是%2個或更少字元. 你輸入了 %3 個字元',
    'noService': '服務不可用',
    'noServiceDesc': '此服務當前不可用${tryAgain}',
    'noInternet': '無法連接到網際網路!',
    'noInternetDesc': '請檢查你的網路連線或稍後重試',
    'blocked': '我們的網站可能被封鎖了!',
    'blockedDesc': '我們的網站可能被您的防火牆或防毒軟體阻擋了，請檢查您的防火牆或防毒軟體設置',
    'diskError': '寫入錯誤!',
    'diskErrorDesc': '請檢查是否空間不足或是權限不夠',
    'timeout': '操作已經超時!',
    'timeoutDesc': '您的操作沒有得到伺服器回應，可能是伺服器目前忙碌中${tryAgain}',
    'firewallBlock': '操作過於頻繁${tryAgain}',
  };
}

Map _zh_CN() {
  var tryAgain = '，请稍后再试';
  return {
    'errTitle': '糟了，有东西出错',
    'notified': '发生的错误已被记录并且通知了我们的开发团队${tryAgain}',
    'error': '错误',
    'email': '电子邮件',
    'emailUs': '發送电子邮件给我们',
    'errCode': '错误代码: ',
    'retry': '重试',
    'ok': '确定',
    'cancel': '取消',
    'close': '关闭',
    'back': '返回',
    'yes': '是',
    'no': '否',
    'delete': '删除',
    'save': '存档',
    'slow': '您的网路速度比平时慢',
    'required': '%1必须填写',
    'validator': '请输入一个有效的%1.  (范例: %2)',
    'emailAdr': '电子邮件地址',
    'domain': '域名',
    'url': '网址',
    'youMean': '您想输入的是: ',
    'enterYour': '输入你的%1',
    'minLength': '%1必须至少包含 %2 个字元. 您输入了 %3 个字元',
    'maxLength': '%1必须是%2个或更少字元. 您输入了 %3 个字元',
    'noService': '服務不可用',
    'noServiceDesc': '服務暫時不可用${tryAgain}',
    'noInternet': '无法连接到互联网!',
    'noInternetDesc': '请检查你的网路连线或稍后重试',
    'blocked': '我们的网站可能被封锁了!',
    'blockedDesc': '我们的网站可能被您的防火墙或防毒软体阻挡了，请检查您的防火墙或防毒软体设置',
    'diskError': '写入错误!',
    'diskErrorDesc': '请检查是否空间不足或是权限不够',
    'timeout': '操作已经超时!',
    'timeoutDesc': '您的操作没有得到服务器回应，可能是服务器目前忙碌中${tryAgain}',
    'firewallBlock': '操作过于频繁${tryAgain}',
  };
}
