// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class LocalizationAz extends Localization {
  LocalizationAz([String locale = 'az']) : super(locale);

  @override
  String get cli_error_oops => 'Ups, nəsə səhv getdi';

  @override
  String get cli_error_content => 'Gözlənilməz xəta baş verdi. E-poçt hesabatı göndərmək istəyirsiniz?';

  @override
  String get cli_error_report => 'Bizə e-poçt göndərin';

  @override
  String get submit => 'Göndər';

  @override
  String get ok => 'Tamam';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get yes => 'Bəli';

  @override
  String get no => 'Xeyr';

  @override
  String get close => 'Bağla';

  @override
  String get back => 'Geri';

  @override
  String get system_language => 'Sistem Dili';
}
