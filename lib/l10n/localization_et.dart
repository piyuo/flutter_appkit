// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class LocalizationEt extends Localization {
  LocalizationEt([String locale = 'et']) : super(locale);

  @override
  String get cli_error_oops => 'Ups, midagi läks valesti';

  @override
  String get cli_error_content =>
      'Ilmnes ootamatu viga. Kas soovite saata e-posti aruande?';

  @override
  String get cli_error_report => 'Saada meile e-kiri';

  @override
  String get submit => 'Saada';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Tühista';

  @override
  String get yes => 'Jah';

  @override
  String get no => 'Ei';

  @override
  String get close => 'Sulge';

  @override
  String get back => 'Tagasi';

  @override
  String get system_language => 'Süsteemi keel';
}
