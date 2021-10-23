import 'package:libcli/i18n/i18n.dart' as i18n;

/// I10nLocalization add localization function to string
///
extension L10nLocalization on String {
  /// l10n_ translate const string defined in local dict, don't use this method on string variable
  ///
  ///   'ERROR'.i18n_; // OK
  String get l10n => i18n.lookup(
        this,
        'uploader',
        _enUS,
        zhTW: _zhTW,
        zhCN: _zhCN,
      );
}

String? _enUS(String key) => {
      'dropImg': 'Drop your image here, or ',
      'tap': 'tap to browse',
      'drop': 'Drop files here',
      'upload': 'Upload',
      'tooBig': 'image file is too big. your image size is %1, try sending a file smaller than %2',
      'notValid': 'not a valid image. Only JPG, PNG, GIF and WEBP files are allowed',
    }[key];

String? _zhTW(String key) => {
      'dropImg': '拖放圖片到這裡或',
      'tap': '按此瀏覽你的圖片',
      'drop': '在這裡放下檔案',
      'upload': '上傳',
      'tooBig': '圖片太大. 你的圖片大小是 %1, 請選擇小於 %2 的圖片',
      'notValid': '圖片格式不支援. 請選擇 JPG, PNG, GIF 以及 WEBP 格式的圖片',
    }[key];

String? _zhCN(String key) => {
      'dropImg': '拖放图片到这裡或',
      'tap': '按此浏览你的图片',
      'drop': '在这裡放下文件',
      'upload': '上传',
      'tooBig': '图片太大. 你的图片大小是 %1, 请选择小于 %2 的图片',
      'notValid': '图片格式不支持. 请选择 JPG, PNG, GIF 以及 WEBP 格式的图片',
    }[key];
