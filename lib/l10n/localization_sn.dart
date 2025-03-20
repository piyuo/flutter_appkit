// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Shona (`sn`).
class LocalizationSn extends Localization {
  LocalizationSn([String locale = 'sn']) : super(locale);

  @override
  String get cli_error_oops => 'Haiwa, pane chakakanganisika';

  @override
  String get cli_error_content => 'Pane chikanganiso chakaitika. Munoda kutumira ripoti neimeri here?';

  @override
  String get cli_error_report => 'Titumireiwo imeri';

  @override
  String get submit => 'Tumira';

  @override
  String get ok => 'Zvakanaka';

  @override
  String get cancel => 'Kanzura';

  @override
  String get yes => 'Hongu';

  @override
  String get no => 'Kwete';

  @override
  String get close => 'Vhara';

  @override
  String get back => 'Dzokera';
}
