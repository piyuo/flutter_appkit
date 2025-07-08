// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class LocalizationSw extends Localization {
  LocalizationSw([String locale = 'sw']) : super(locale);

  @override
  String get back => 'Rudi';

  @override
  String get cancel => 'Ghairi';

  @override
  String get close => 'Funga';

  @override
  String get managed_error_content =>
      'Hitilafu isiyotarajiwa imetokea. Tayari tumerejelea hitilafu hii. Tafadhali jaribu tena baadaye.';

  @override
  String get managed_error_oops => 'Samahani, kuna hitilafu imetokea';

  @override
  String get no => 'La';

  @override
  String get ok => 'Sawa';

  @override
  String get submit => 'Wasilisha';

  @override
  String get system_language => 'Lugha ya Mfumo';

  @override
  String get yes => 'Ndio';
}
