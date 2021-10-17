import 'package:libcli/i18n.dart' as i18n;

/// I10nLocalization add localization function to string
///
extension L10nLocalization on String {
  /// l10n_ translate const string defined in local dict, don't use this method on string variable
  ///
  ///   'ERROR'.i18n_; // OK
  String get l10n => i18n.lookup(
        this,
        'barcode',
        _enUS,
        zhTW: _zhTW,
        zhCN: _zhCN,
      );
}

String? _enUS(String key) => {
      'noAccessCamera': 'No access to camera',
      'scanQR': 'Scan QR code',
    }[key];

String? _zhTW(String key) => {
      'noAccessCamera': '沒有權限存取相機',
      'scanQR': '掃描二維碼',
    }[key];

String? _zhCN(String key) => {
      'noAccessCamera': '没有权限存取相机',
      'scanQR': '扫描二维码',
    }[key];
