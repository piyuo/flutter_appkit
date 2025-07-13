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
      '예기치 않은 오류가 발생했습니다. 이미 이 오류를 기록했습니다. 나중에 다시 시도해주세요.';

  @override
  String get error_oops => '앗, 문제가 발생했습니다';

  @override
  String get language => '시스템 언어';
}
