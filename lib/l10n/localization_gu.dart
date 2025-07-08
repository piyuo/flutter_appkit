// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class LocalizationGu extends Localization {
  LocalizationGu([String locale = 'gu']) : super(locale);

  @override
  String get back => 'પાછળ';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get close => 'બંધ કરો';

  @override
  String get managed_error_content =>
      'અનપેક્ષિત ભૂલ આવી. અમે આ ભૂલ પહેલાથી લોગ કરી છે. કૃપા કરીને પછી ફરી પ્રયાસ કરો.';

  @override
  String get managed_error_oops => 'અરે, કંઈક ખોટું થયું';

  @override
  String get no => 'ના';

  @override
  String get ok => 'ઠીક છે';

  @override
  String get submit => 'સબમિટ કરો';

  @override
  String get system_language => 'સિસ્ટમ ભાષા';

  @override
  String get yes => 'હા';
}
