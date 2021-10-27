import 'package:libcli/i18n/i18n.dart' as i18n;

/// I10nLocalization add localization function to string
///
extension L10nLocalization on String {
  /// l10n_ translate const string defined in local dict, don't use this method on string variable
  ///
  ///   'ERROR'.i18n_; // OK
  String get l10n => i18n.lookup(
        this,
        'paged',
        _enUS,
        zhTW: _zhTW,
        zhCN: _zhCN,
      );
}

String? _enUS(String key) => {
      'pagingMany': 'of many',
      'pagingCount': 'of %1',
      'noData': 'No data',
      'archive': 'Archive',
    }[key];

String? _zhTW(String key) => {
      'pagingMany': '共很多',
      'pagingCount': '共 %1 筆',
      'noData': '無資料',
      'archive': '封存',
    }[key];

String? _zhCN(String key) => {
      'pagingMany': '共很多',
      'pagingCount': '共 %1 笔',
      'noData': '无资料',
      'archive': '封存',
    }[key];
