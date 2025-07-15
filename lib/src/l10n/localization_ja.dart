// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class LocalizationJa extends Localization {
  LocalizationJa([String locale = 'ja']) : super(locale);

  @override
  String get close => '閉じる';

  @override
  String get error_content =>
      '予期せぬエラーが発生しました。改善にご協力いただくためレポートをお送りいただくか、後でもう一度お試しください。';

  @override
  String get error_oops => 'おっと、問題が発生しました';

  @override
  String get error_report_anonymously => '匿名レポートを送信して改善にご協力ください';

  @override
  String get language => 'システム言語';
}
