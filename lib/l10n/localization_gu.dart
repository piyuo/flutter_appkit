// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class LocalizationGu extends Localization {
  LocalizationGu([String locale = 'gu']) : super(locale);

  @override
  String get cli_error_oops => 'અરે, કંઈક ખોટું થયું';

  @override
  String get cli_error_content => 'અનપેક્ષિત ભૂલ આવી. શું તમે ઈમેલ રિપોર્ટ મોકલવા માંગો છો?';

  @override
  String get cli_error_report => 'અમને ઈમેલ કરો';

  @override
  String get submit => 'સબમિટ કરો';

  @override
  String get ok => 'ઠીક છે';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get yes => 'હા';

  @override
  String get no => 'ના';

  @override
  String get close => 'બંધ કરો';

  @override
  String get back => 'પાછળ';
}
