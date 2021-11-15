import 'package:libcli/i18n/i18n.dart' as i18n;

/// I10nLocalization add localization function to string
///
extension L10nLocalization on String {
  /// l10n_ translate const string defined in local dict, don't use this method on string variable
  ///
  ///   'ERROR'.i18n_; // OK
  String get l10n => i18n.lookup(
        this,
        'delta',
        _enUS,
        zhTW: _zhTW,
        zhCN: _zhCN,
      );
}

String? _enUS(String key) => {
      'notSupport': 'Web mode does not support %1, Please install our native app',
      'permission': 'This app requires access to the %1 , do you want allow it in app setting?',
      'bluetooth': 'bluetooth',
      'camera': 'camera',
      'location': 'location',
      'photo': 'photo',
      'notification': 'notification',
      'mic': 'microphone',
      'gotoSetting': 'Go to setting',
    }[key];

String? _zhTW(String key) => {
      'notSupport': '網頁模式不支援%1，請安裝我們的原生 APP',
      'permission': '我們需要權限存取%1, 您想去設定頁面開啟相機權限嗎?',
      'bluetooth': '藍芽',
      'camera': '相機',
      'location': '位置',
      'photo': '相片',
      'notification': '通知',
      'mic': '麥克風',
      'gotoSetting': '去設定頁面',
    }[key];

String? _zhCN(String key) => {
      'notSupport': '网页模式不支援%1，请安装我们的原生 APP',
      'permission': '我们需要权限存取%1, 您想去设定页面开启相机权限吗?',
      'bluetooth': '蓝芽',
      'camera': '相机',
      'location': '位置',
      'photo': '相片',
      'notification': '通知',
      'mic': '麦克风',
      'gotoSetting': '去设定页面',
    }[key];
