// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class LocalizationAz extends Localization {
  LocalizationAz([String locale = 'az']) : super(locale);

  @override
  String get back => 'Geri';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get close => 'Bağla';

  @override
  String get managed_error_content =>
      'Gözlənilməz xəta baş verdi. Bu xətanı artıq qeyd etdik. Xahiş edirik sonra yenidən cəhd edin.';

  @override
  String get managed_error_oops => 'Ups, nəsə səhv getdi';

  @override
  String get no => 'Xeyr';

  @override
  String get ok => 'Tamam';

  @override
  String get submit => 'Göndər';

  @override
  String get system_language => 'Sistem Dili';

  @override
  String get yes => 'Bəli';
}
