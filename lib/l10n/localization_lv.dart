// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class LocalizationLv extends Localization {
  LocalizationLv([String locale = 'lv']) : super(locale);

  @override
  String get back => 'Atpakaļ';

  @override
  String get cancel => 'Atcelt';

  @override
  String get close => 'Aizvērt';

  @override
  String get managed_error_content =>
      'Notika neparedzēta kļūda. Mēs jau esam reģistrējuši šo kļūdu. Lūdzu, mēģiniet vēlāk.';

  @override
  String get managed_error_oops => 'Ak vai, kaut kas nogāja greizi';

  @override
  String get no => 'Nē';

  @override
  String get ok => 'Labi';

  @override
  String get submit => 'Iesniegt';

  @override
  String get system_language => 'Sistēmas valoda';

  @override
  String get yes => 'Jā';
}
