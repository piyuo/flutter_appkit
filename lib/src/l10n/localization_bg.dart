// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class LocalizationBg extends Localization {
  LocalizationBg([String locale = 'bg']) : super(locale);

  @override
  String get close => 'Затвори';

  @override
  String get error_content =>
      'Възникна неочаквана грешка. Вече записахме тази грешка. Моля, опитайте отново по-късно.';

  @override
  String get error_oops => 'Опа, нещо се обърка';

  @override
  String get language => 'Език на системата';
}
