// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class LocalizationSl extends Localization {
  LocalizationSl([String locale = 'sl']) : super(locale);

  @override
  String get close => 'Zapri';

  @override
  String get error_content =>
      'Prišlo je do nepričakovane napake. To napako smo že zabeležili. Poskusite znova pozneje.';

  @override
  String get error_oops => 'Ups, nekaj je šlo narobe';

  @override
  String get language => 'Sistemski jezik';
}
