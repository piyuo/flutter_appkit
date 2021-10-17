import 'package:libcli/i18n.dart' as i18n;

/// I10nLocalization add localization function to string
///
extension L10nLocalization on String {
  /// l10n_ translate const string defined in local dict, don't use this method on string variable
  ///
  ///   'ERROR'.i18n_; // OK
  String get l10n => i18n.lookup(
        this,
        'editor',
        _enUS,
        zhTW: _zhTW,
        zhCN: _zhCN,
      );
}

String? _enUS(String key) => {
      'webCamera': 'Web mode does not support camera, Please install our native app',
      'appSetting': 'We need access to camera, do you want allow it in app setting?',
      'gotoSetting': 'go to setting',
    }[key];

String? _zhTW(String key) => {
      'webCamera': '網頁模式不支援相機，請安裝我們的原生 APP',
      'appSetting': '我們需要權限存取相機, 您想去設定頁面開啟相機權限嗎?',
      'gotoSetting': '去設定頁面',
    }[key];

String? _zhCN(String key) => {
      'webCamera': '网页模式不支援相机，请安装我们的原生 APP',
      'appSetting': '我们需要权限存取相机, 您想去设定页面开启相机权限吗?',
      'gotoSetting': '去设定页面',
    }[key];
