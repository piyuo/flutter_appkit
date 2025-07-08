// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class LocalizationBg extends Localization {
  LocalizationBg([String locale = 'bg']) : super(locale);

  @override
  String get back => 'Назад';

  @override
  String get cancel => 'Отказ';

  @override
  String get close => 'Затвори';

  @override
  String get managed_error_content =>
      'Възникна неочаквана грешка. Вече записахме тази грешка. Моля, опитайте отново по-късно.';

  @override
  String get managed_error_oops => 'Опа, нещо се обърка';

  @override
  String get no => 'Не';

  @override
  String get ok => 'ОК';

  @override
  String get submit => 'Изпрати';

  @override
  String get system_language => 'Език на системата';

  @override
  String get yes => 'Да';
}
