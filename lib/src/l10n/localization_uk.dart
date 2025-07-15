// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class LocalizationUk extends Localization {
  LocalizationUk([String locale = 'uk']) : super(locale);

  @override
  String get close => 'Закрити';

  @override
  String get error_content =>
      'Сталася неочікувана помилка. Ви можете надіслати нам звіт, щоб допомогти нам покращитися, або спробуйте ще раз пізніше.';

  @override
  String get error_oops => 'Упс, щось пішло не так';

  @override
  String get error_report_anonymously =>
      'Допоможіть нам покращитися, надіславши анонімний звіт';

  @override
  String get language => 'Мова системи';
}
