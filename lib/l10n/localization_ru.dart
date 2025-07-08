// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class LocalizationRu extends Localization {
  LocalizationRu([String locale = 'ru']) : super(locale);

  @override
  String get back => 'Назад';

  @override
  String get cancel => 'Отмена';

  @override
  String get close => 'Закрыть';

  @override
  String get managed_error_content =>
      'Произошла непредвиденная ошибка. Мы уже зарегистрировали эту ошибку. Пожалуйста, попробуйте снова позже.';

  @override
  String get managed_error_oops => 'Упс, что-то пошло не так';

  @override
  String get no => 'Нет';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Отправить';

  @override
  String get system_language => 'Язык системы';

  @override
  String get yes => 'Да';
}

/// The translations for Russian, as used in Kazakhstan (`ru_KZ`).
class LocalizationRuKz extends LocalizationRu {
  LocalizationRuKz() : super('ru_KZ');

  @override
  String get back => 'Назад';

  @override
  String get cancel => 'Отмена';

  @override
  String get close => 'Закрыть';

  @override
  String get managed_error_content =>
      'Произошла непредвиденная ошибка. Мы уже зарегистрировали эту ошибку. Пожалуйста, попробуйте снова позже.';

  @override
  String get managed_error_oops => 'Упс, что-то пошло не так';

  @override
  String get no => 'Нет';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Отправить';

  @override
  String get system_language => 'Мова системи';

  @override
  String get yes => 'Да';
}

/// The translations for Russian, as used in Ukraine (`ru_UA`).
class LocalizationRuUa extends LocalizationRu {
  LocalizationRuUa() : super('ru_UA');

  @override
  String get back => 'Назад';

  @override
  String get cancel => 'Отмена';

  @override
  String get close => 'Закрыть';

  @override
  String get managed_error_content =>
      'Произошла непредвиденная ошибка. Мы уже зарегистрировали эту ошибку. Пожалуйста, попробуйте снова позже.';

  @override
  String get managed_error_oops => 'Упс, что-то пошло не так';

  @override
  String get no => 'Нет';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Отправить';

  @override
  String get system_language => 'Системски језик';

  @override
  String get yes => 'Да';
}
