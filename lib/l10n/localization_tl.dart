// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Tagalog (`tl`).
class LocalizationTl extends Localization {
  LocalizationTl([String locale = 'tl']) : super(locale);

  @override
  String get back => 'Bumalik';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get close => 'Isara';

  @override
  String get managed_error_content =>
      'Mayroong hindi inaasahang error na nangyari. Na-log na namin ang error na ito. Pakisubukan ulit mamaya.';

  @override
  String get managed_error_oops => 'Oops, may mali na nangyari';

  @override
  String get no => 'Hindi';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Isumite';

  @override
  String get system_language => 'Wika ng sistema';

  @override
  String get yes => 'Oo';
}
