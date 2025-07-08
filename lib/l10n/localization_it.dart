// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class LocalizationIt extends Localization {
  LocalizationIt([String locale = 'it']) : super(locale);

  @override
  String get back => 'Indietro';

  @override
  String get cancel => 'Annulla';

  @override
  String get close => 'Chiudi';

  @override
  String get managed_error_content =>
      'Si è verificato un errore imprevisto. Abbiamo già registrato questo errore. Riprova più tardi.';

  @override
  String get managed_error_oops => 'Ops, qualcosa è andato storto';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Invia';

  @override
  String get system_language => 'Lingua di sistema';

  @override
  String get yes => 'Sì';
}
