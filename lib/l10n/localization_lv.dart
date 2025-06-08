// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class LocalizationLv extends Localization {
  LocalizationLv([String locale = 'lv']) : super(locale);

  @override
  String get cli_error_oops => 'Ak vai, kaut kas nogāja greizi';

  @override
  String get cli_error_content =>
      'Notika neparedzēta kļūda. Vai vēlaties nosūtīt ziņojumu pa e-pastu?';

  @override
  String get cli_error_report => 'Rakstiet mums e-pastu';

  @override
  String get submit => 'Iesniegt';

  @override
  String get ok => 'Labi';

  @override
  String get cancel => 'Atcelt';

  @override
  String get yes => 'Jā';

  @override
  String get no => 'Nē';

  @override
  String get close => 'Aizvērt';

  @override
  String get back => 'Atpakaļ';

  @override
  String get system_language => 'Sistēmas valoda';
}
