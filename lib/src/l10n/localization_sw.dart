// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class LocalizationSw extends Localization {
  LocalizationSw([String locale = 'sw']) : super(locale);

  @override
  String get close => 'Funga';

  @override
  String get error_content =>
      'Hitilafu isiyotarajiwa imetokea. Tayari tumerejelea hitilafu hii. Tafadhali jaribu tena baadaye.';

  @override
  String get error_oops => 'Samahani, kuna hitilafu imetokea';

  @override
  String get language => 'Lugha ya Mfumo';
}
