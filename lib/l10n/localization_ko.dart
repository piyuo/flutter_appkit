// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class LocalizationKo extends Localization {
  LocalizationKo([String locale = 'ko']) : super(locale);

  @override
  String get cli_error_oops => '앗, 문제가 발생했습니다';

  @override
  String get cli_error_content => '예기치 않은 오류가 발생했습니다. 이메일 보고서를 제출하시겠습니까?';

  @override
  String get cli_error_report => '이메일 보내기';

  @override
  String get submit => '제출';

  @override
  String get ok => '확인';

  @override
  String get cancel => '취소';

  @override
  String get yes => '예';

  @override
  String get no => '아니오';

  @override
  String get close => '닫기';

  @override
  String get back => '뒤로';

  @override
  String get system_language => '시스템 언어';
}
