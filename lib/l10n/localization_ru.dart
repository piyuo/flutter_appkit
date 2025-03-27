// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class LocalizationRu extends Localization {
  LocalizationRu([String locale = 'ru']) : super(locale);

  @override
  String get cli_error_oops => 'Упс, что-то пошло не так';

  @override
  String get cli_error_content => 'Произошла непредвиденная ошибка. Хотите отправить отчет по электронной почте?';

  @override
  String get cli_error_report => 'Напишите нам';

  @override
  String get submit => 'Отправить';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Отмена';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get close => 'Закрыть';

  @override
  String get back => 'Назад';

  @override
  String get system_language => 'Язык системы';
}

/// The translations for Russian, as used in Kazakhstan (`ru_KZ`).
class LocalizationRuKz extends LocalizationRu {
  LocalizationRuKz(): super('ru_KZ');

  @override
  String get cli_error_oops => 'Упс, что-то пошло не так';

  @override
  String get cli_error_content => 'Произошла непредвиденная ошибка. Хотите отправить отчет по электронной почте?';

  @override
  String get cli_error_report => 'Напишите нам';

  @override
  String get submit => 'Отправить';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Отмена';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get close => 'Закрыть';

  @override
  String get back => 'Назад';

  @override
  String get system_language => 'Мова системи';
}

/// The translations for Russian, as used in Ukraine (`ru_UA`).
class LocalizationRuUa extends LocalizationRu {
  LocalizationRuUa(): super('ru_UA');

  @override
  String get cli_error_oops => 'Упс, что-то пошло не так';

  @override
  String get cli_error_content => 'Произошла непредвиденная ошибка. Хотите отправить отчет по электронной почте?';

  @override
  String get cli_error_report => 'Напишите нам';

  @override
  String get submit => 'Отправить';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Отмена';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get close => 'Закрыть';

  @override
  String get back => 'Назад';

  @override
  String get system_language => 'Системски језик';
}
