// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class LocalizationSr extends Localization {
  LocalizationSr([String locale = 'sr']) : super(locale);

  @override
  String get back => 'Назад';

  @override
  String get cancel => 'Откажи';

  @override
  String get close => 'Затвори';

  @override
  String get managed_error_content =>
      'Догодила се неочекивана грешка. Већ смо забележили ову грешку. Молимо покушајте поново касније.';

  @override
  String get managed_error_oops => 'Упс, нешто је пошло наопако';

  @override
  String get no => 'Не';

  @override
  String get ok => 'У реду';

  @override
  String get submit => 'Пошаљи';

  @override
  String get system_language => 'Језик система';

  @override
  String get yes => 'Да';
}
