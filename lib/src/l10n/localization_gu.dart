// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class LocalizationGu extends Localization {
  LocalizationGu([String locale = 'gu']) : super(locale);

  @override
  String get close => 'બંધ કરો';

  @override
  String get error_content =>
      'અનપેક્ષિત ભૂલ આવી. અમે આ ભૂલ પહેલાથી લોગ કરી છે. કૃપા કરીને પછી ફરી પ્રયાસ કરો.';

  @override
  String get error_oops => 'અરે, કંઈક ખોટું થયું';

  @override
  String get language => 'સિસ્ટમ ભાષા';
}
