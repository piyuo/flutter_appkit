// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class LocalizationEl extends Localization {
  LocalizationEl([String locale = 'el']) : super(locale);

  @override
  String get cli_error_oops => 'Ωχ, κάτι πήγε στραβά';

  @override
  String get cli_error_content => 'Παρουσιάστηκε ένα απρόσμενο σφάλμα. Θα θέλατε να υποβάλετε μια αναφορά μέσω email;';

  @override
  String get cli_error_report => 'Στείλτε μας email';

  @override
  String get submit => 'Υποβολή';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get yes => 'Ναι';

  @override
  String get no => 'Όχι';

  @override
  String get close => 'Κλείσιμο';

  @override
  String get back => 'Πίσω';

  @override
  String get system_language => 'Γλώσσα συστήματος';
}
