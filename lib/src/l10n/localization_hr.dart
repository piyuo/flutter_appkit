// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class LocalizationHr extends Localization {
  LocalizationHr([String locale = 'hr']) : super(locale);

  @override
  String get close => 'Zatvori';

  @override
  String get error_content =>
      'Došlo je do neočekivane pogreške. Već smo zabilježili ovu grešku. Molimo pokušajte ponovo kasnije.';

  @override
  String get error_oops => 'Ups, nešto je pošlo po krivu';

  @override
  String get language => 'Sistemski jezik';
}
