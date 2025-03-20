// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Pushto Pashto (`ps`).
class LocalizationPs extends Localization {
  LocalizationPs([String locale = 'ps']) : super(locale);

  @override
  String get cli_error_oops => 'افسوس، کومه ستونزه رامنځته شوه';

  @override
  String get cli_error_content => 'یوه ناڅاپي تېروتنه رامنځته شوه. ایا غواړئ د بریښنالیک راپور واستوئ؟';

  @override
  String get cli_error_report => 'موږ ته بریښنالیک واستوئ';

  @override
  String get submit => 'وسپارئ';

  @override
  String get ok => 'سمه ده';

  @override
  String get cancel => 'لغوه کول';

  @override
  String get yes => 'هو';

  @override
  String get no => 'نه';

  @override
  String get close => 'بند کړئ';

  @override
  String get back => 'شاته';
}
