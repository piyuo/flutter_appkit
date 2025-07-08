// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class LocalizationKo extends Localization {
  LocalizationKo([String locale = 'ko']) : super(locale);

  @override
  String get back => '뒤로';

  @override
  String get cancel => '취소';

  @override
  String get close => '닫기';

  @override
  String get managed_error_content =>
      '예기치 않은 오류가 발생했습니다. 이미 이 오류를 기록했습니다. 나중에 다시 시도해주세요.';

  @override
  String get managed_error_oops => '앗, 문제가 발생했습니다';

  @override
  String get no => '아니오';

  @override
  String get ok => '확인';

  @override
  String get submit => '제출';

  @override
  String get system_language => '시스템 언어';

  @override
  String get yes => '예';
}
