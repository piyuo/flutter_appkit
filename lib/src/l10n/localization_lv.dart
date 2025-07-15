// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class LocalizationLv extends Localization {
  LocalizationLv([String locale = 'lv']) : super(locale);

  @override
  String get close => 'Aizvērt';

  @override
  String get error_content =>
      'Notika neparedzēta kļūda. Jūs varat nosūtīt mums ziņojumu, lai palīdzētu mums uzlaboties, vai mēģiniet vēlāk.';

  @override
  String get error_oops => 'Ak vai, kaut kas nogāja greizi';

  @override
  String get error_report_anonymously =>
      'Palīdziet mums uzlaboties, nosūtot anonīmu ziņojumu';

  @override
  String get language => 'Sistēmas valoda';
}
