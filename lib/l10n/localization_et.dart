// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class LocalizationEt extends Localization {
  LocalizationEt([String locale = 'et']) : super(locale);

  @override
  String get back => 'Tagasi';

  @override
  String get cancel => 'Tühista';

  @override
  String get close => 'Sulge';

  @override
  String get managed_error_content =>
      'Ilmnes ootamatu viga. Oleme selle vea juba registreerinud. Palun proovige hiljem uuesti.';

  @override
  String get managed_error_oops => 'Ups, midagi läks valesti';

  @override
  String get no => 'Ei';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Saada';

  @override
  String get system_language => 'Süsteemi keel';

  @override
  String get yes => 'Jah';
}
