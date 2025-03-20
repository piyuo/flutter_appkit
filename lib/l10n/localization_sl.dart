// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class LocalizationSl extends Localization {
  LocalizationSl([String locale = 'sl']) : super(locale);

  @override
  String get cli_error_oops => 'Ups, nekaj je šlo narobe';

  @override
  String get cli_error_content => 'Prišlo je do nepričakovane napake. Ali želite poslati poročilo po e-pošti?';

  @override
  String get cli_error_report => 'Pošljite nam e-pošto';

  @override
  String get submit => 'Pošlji';

  @override
  String get ok => 'V redu';

  @override
  String get cancel => 'Prekliči';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Ne';

  @override
  String get close => 'Zapri';

  @override
  String get back => 'Nazaj';
}
