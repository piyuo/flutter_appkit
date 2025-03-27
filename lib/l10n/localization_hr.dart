// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class LocalizationHr extends Localization {
  LocalizationHr([String locale = 'hr']) : super(locale);

  @override
  String get cli_error_oops => 'Ups, nešto je pošlo po krivu';

  @override
  String get cli_error_content => 'Došlo je do neočekivane pogreške. Želite li poslati izvješće e-poštom?';

  @override
  String get cli_error_report => 'Pošaljite nam e-poštu';

  @override
  String get submit => 'Pošalji';

  @override
  String get ok => 'U redu';

  @override
  String get cancel => 'Odustani';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Ne';

  @override
  String get close => 'Zatvori';

  @override
  String get back => 'Natrag';

  @override
  String get system_language => 'Sistemski jezik';
}
