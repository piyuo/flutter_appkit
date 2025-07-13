// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class LocalizationSr extends Localization {
  LocalizationSr([String locale = 'sr']) : super(locale);

  @override
  String get close => 'Затвори';

  @override
  String get error_content =>
      'Догодила се неочекивана грешка. Већ смо забележили ову грешку. Молимо покушајте поново касније.';

  @override
  String get error_oops => 'Упс, нешто је пошло наопако';

  @override
  String get language => 'Језик система';
}
