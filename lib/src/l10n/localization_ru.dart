// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class LocalizationRu extends Localization {
  LocalizationRu([String locale = 'ru']) : super(locale);

  @override
  String get close => 'Закрыть';

  @override
  String get error_content =>
      'Произошла непредвиденная ошибка. Вы можете отправить нам отчет, чтобы помочь нам улучшиться, или попробуйте снова позже.';

  @override
  String get error_oops => 'Упс, что-то пошло не так';

  @override
  String get error_report_anonymously =>
      'Помогите нам улучшиться, отправив анонимный отчет';

  @override
  String get language => 'Язык системы';
}

/// The translations for Russian, as used in Kazakhstan (`ru_KZ`).
class LocalizationRuKz extends LocalizationRu {
  LocalizationRuKz() : super('ru_KZ');

  @override
  String get close => 'Закрыть';

  @override
  String get error_content =>
      'Произошла непредвиденная ошибка. Вы можете отправить нам отчет, чтобы помочь нам улучшиться, или попробуйте снова позже.';

  @override
  String get error_oops => 'Упс, что-то пошло не так';

  @override
  String get error_report_anonymously =>
      'Помогите нам улучшиться, отправив анонимный отчет';

  @override
  String get language => 'Мова системи';
}

/// The translations for Russian, as used in Ukraine (`ru_UA`).
class LocalizationRuUa extends LocalizationRu {
  LocalizationRuUa() : super('ru_UA');

  @override
  String get close => 'Закрыть';

  @override
  String get error_content =>
      'Произошла непредвиденная ошибка. Вы можете отправить нам отчет, чтобы помочь нам улучшиться, или попробуйте снова позже.';

  @override
  String get error_oops => 'Упс, что-то пошло не так';

  @override
  String get error_report_anonymously =>
      'Помогите нам улучшиться, отправив анонимный отчет';

  @override
  String get language => 'Системски језик';
}
