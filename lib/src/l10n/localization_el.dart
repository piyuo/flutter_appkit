// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class LocalizationEl extends Localization {
  LocalizationEl([String locale = 'el']) : super(locale);

  @override
  String get close => 'Κλείσιμο';

  @override
  String get error_content =>
      'Παρουσιάστηκε ένα απρόσμενο σφάλμα. Μπορείτε να μας στείλετε μια αναφορά για να μας βοηθήσετε να βελτιωθούμε, ή δοκιμάστε ξανά αργότερα.';

  @override
  String get error_oops => 'Ωχ, κάτι πήγε στραβά';

  @override
  String get error_report_anonymously =>
      'Βοηθήστε μας να βελτιωθούμε στέλνοντας μια ανώνυμη αναφορά';

  @override
  String get language => 'Γλώσσα συστήματος';
}
