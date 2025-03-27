// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class LocalizationTr extends Localization {
  LocalizationTr([String locale = 'tr']) : super(locale);

  @override
  String get cli_error_oops => 'Hata, bir şeyler yanlış gitti';

  @override
  String get cli_error_content => 'Beklenmeyen bir hata oluştu. E-posta raporu göndermek ister misiniz?';

  @override
  String get cli_error_report => 'Bize e-posta gönderin';

  @override
  String get submit => 'Gönder';

  @override
  String get ok => 'Tamam';

  @override
  String get cancel => 'İptal';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get close => 'Kapat';

  @override
  String get back => 'Geri';

  @override
  String get system_language => 'Sistem Dili';
}
