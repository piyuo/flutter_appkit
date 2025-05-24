// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class LocalizationSr extends Localization {
  LocalizationSr([String locale = 'sr']) : super(locale);

  @override
  String get cli_error_oops => 'Упс, нешто је пошло наопако';

  @override
  String get cli_error_content =>
      'Догодила се неочекивана грешка. Да ли желите да пошаљете извештај е-поштом?';

  @override
  String get cli_error_report => 'Пошаљите нам е-пошту';

  @override
  String get submit => 'Пошаљи';

  @override
  String get ok => 'У реду';

  @override
  String get cancel => 'Откажи';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Не';

  @override
  String get close => 'Затвори';

  @override
  String get back => 'Назад';

  @override
  String get system_language => 'Језик система';
}
