// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class LocalizationJa extends Localization {
  LocalizationJa([String locale = 'ja']) : super(locale);

  @override
  String get cli_error_oops => 'おっと、問題が発生しました';

  @override
  String get cli_error_content => '予期せぬエラーが発生しました。メールでレポートを送信しますか？';

  @override
  String get cli_error_report => 'メールで連絡する';

  @override
  String get submit => '送信';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get close => '閉じる';

  @override
  String get back => '戻る';

  @override
  String get system_language => 'システム言語';
}
