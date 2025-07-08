// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class LocalizationKk extends Localization {
  LocalizationKk([String locale = 'kk']) : super(locale);

  @override
  String get back => 'Артқа';

  @override
  String get cancel => 'Болдырмау';

  @override
  String get close => 'Жабу';

  @override
  String get managed_error_content =>
      'Күтпеген қате орын алды. Біз бұл қатені әлдеқашан журналға енгіздік. Кейінірек қайталап көріңіз.';

  @override
  String get managed_error_oops => 'Ойбай, бір нәрсе дұрыс болмады';

  @override
  String get no => 'Жоқ';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Жіберу';

  @override
  String get system_language => 'Жүйе тілі';

  @override
  String get yes => 'Иә';
}
