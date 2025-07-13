// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class LocalizationEt extends Localization {
  LocalizationEt([String locale = 'et']) : super(locale);

  @override
  String get close => 'Sulge';

  @override
  String get error_content =>
      'Ilmnes ootamatu viga. Oleme selle vea juba registreerinud. Palun proovige hiljem uuesti.';

  @override
  String get error_oops => 'Ups, midagi läks valesti';

  @override
  String get language => 'Süsteemi keel';
}
