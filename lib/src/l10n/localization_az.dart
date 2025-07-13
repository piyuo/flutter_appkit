// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class LocalizationAz extends Localization {
  LocalizationAz([String locale = 'az']) : super(locale);

  @override
  String get close => 'Bağla';

  @override
  String get error_content =>
      'Gözlənilməz xəta baş verdi. Bu xətanı artıq qeyd etdik. Xahiş edirik sonra yenidən cəhd edin.';

  @override
  String get error_oops => 'Ups, nəsə səhv getdi';

  @override
  String get language => 'Sistem Dili';
}
