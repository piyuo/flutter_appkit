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
      'save': '保存',
      'resize': '變更圖片大小',
      'flip': '翻轉',
      'rl': '向左旋轉',
      'rr': '向右旋轉',
      'reset': '重置圖片',
    }[key];

String? _zhCN(String key) => {
      'save': '保存',
      'resize': '变更图片大小',
      'flip': '翻转',
      'rl': '向左旋转',
      'rr': '向右旋转',
      'reset': '重置图片',
    }[key];
