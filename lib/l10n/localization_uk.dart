// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class LocalizationUk extends Localization {
  LocalizationUk([String locale = 'uk']) : super(locale);

  @override
  String get back => 'Назад';

  @override
  String get cancel => 'Скасувати';

  @override
  String get close => 'Закрити';

  @override
  String get managed_error_content =>
      'Сталася неочікувана помилка. Ми вже зареєстрували цю помилку. Будь ласка, спробуйте ще раз пізніше.';

  @override
  String get managed_error_oops => 'Упс, щось пішло не так';

  @override
  String get no => 'Ні';

  @override
  String get ok => 'Гаразд';

  @override
  String get submit => 'Надіслати';

  @override
  String get system_language => 'Мова системи';

  @override
  String get yes => 'Так';
}
