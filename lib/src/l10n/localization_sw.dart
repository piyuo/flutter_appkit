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
      'Hitilafu isiyotarajiwa imetokea. Unaweza kutuma ripoti kwetu ili kutusaidia kuboresha, au jaribu tena baadaye.';

  @override
  String get error_oops => 'Samahani, kuna hitilafu imetokea';

  @override
  String get error_report_anonymously =>
      'Tusaidie kuboresha kwa kutuma ripoti ya siri';

  @override
  String get language => 'Lugha ya Mfumo';
}
