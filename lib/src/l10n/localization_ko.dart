// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class LocalizationKo extends Localization {
  LocalizationKo([String locale = 'ko']) : super(locale);

  @override
  String get close => '닫기';

  @override
  String get error_content =>
      '예기치 않은 오류가 발생했습니다. 개선에 도움을 주기 위해 보고서를 보내주시거나 나중에 다시 시도해주세요.';

  @override
  String get error_oops => '앗, 문제가 발생했습니다';

  @override
  String get error_report_anonymously => '익명 보고서를 보내 개선에 도움을 주세요';

  @override
  String get language => '시스템 언어';
}
