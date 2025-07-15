// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Tagalog (`tl`).
class LocalizationTl extends Localization {
  LocalizationTl([String locale = 'tl']) : super(locale);

  @override
  String get close => 'Isara';

  @override
  String get error_content =>
      'Mayroong hindi inaasahang error na nangyari. Maaari kang magpadala sa amin ng ulat para matulungan kaming mapabuti, o subukan ulit mamaya.';

  @override
  String get error_oops => 'Oops, may mali na nangyari';

  @override
  String get error_report_anonymously =>
      'Tulungang mapabuti kami sa pamamagitan ng pagpapadala ng anonymous na ulat';

  @override
  String get language => 'Wika ng sistema';
}
