// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class LocalizationEl extends Localization {
  LocalizationEl([String locale = 'el']) : super(locale);

  @override
  String get back => 'Πίσω';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get close => 'Κλείσιμο';

  @override
  String get managed_error_content =>
      'Παρουσιάστηκε ένα απρόσμενο σφάλμα. Έχουμε ήδη καταγράψει αυτό το σφάλμα. Παρακαλώ δοκιμάστε ξανά αργότερα.';

  @override
  String get managed_error_oops => 'Ωχ, κάτι πήγε στραβά';

  @override
  String get no => 'Όχι';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Υποβολή';

  @override
  String get system_language => 'Γλώσσα συστήματος';

  @override
  String get yes => 'Ναι';
}
