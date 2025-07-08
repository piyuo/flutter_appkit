// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class LocalizationLt extends Localization {
  LocalizationLt([String locale = 'lt']) : super(locale);

  @override
  String get back => 'Atgal';

  @override
  String get cancel => 'Atšaukti';

  @override
  String get close => 'Uždaryti';

  @override
  String get managed_error_content =>
      'Įvyko netikėta klaida. Jau užregistravome šią klaidą. Bandykite dar kartą vėliau.';

  @override
  String get managed_error_oops => 'Oi, kažkas nutiko';

  @override
  String get no => 'Ne';

  @override
  String get ok => 'Gerai';

  @override
  String get submit => 'Pateikti';

  @override
  String get system_language => 'Sistemos kalba';

  @override
  String get yes => 'Taip';
}
