// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class LocalizationJa extends Localization {
  LocalizationJa([String locale = 'ja']) : super(locale);

  @override
  String get back => '戻る';

  @override
  String get cancel => 'キャンセル';

  @override
  String get close => '閉じる';

  @override
  String get managed_error_content =>
      '予期せぬエラーが発生しました。このエラーはすでに記録されています。後でもう一度お試しください。';

  @override
  String get managed_error_oops => 'おっと、問題が発生しました';

  @override
  String get no => 'いいえ';

  @override
  String get ok => 'OK';

  @override
  String get submit => '送信';

  @override
  String get system_language => 'システム言語';

  @override
  String get yes => 'はい';
}
