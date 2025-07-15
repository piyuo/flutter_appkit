// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class LocalizationIt extends Localization {
  LocalizationIt([String locale = 'it']) : super(locale);

  @override
  String get close => 'Chiudi';

  @override
  String get error_content =>
      'Si è verificato un errore imprevisto. Puoi inviarci un rapporto per aiutarci a migliorare, o riprova più tardi.';

  @override
  String get error_oops => 'Ops, qualcosa è andato storto';

  @override
  String get error_report_anonymously =>
      'Aiutaci a migliorare inviando un rapporto anonimo';

  @override
  String get language => 'Lingua di sistema';
}
