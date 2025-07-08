// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class LocalizationTr extends Localization {
  LocalizationTr([String locale = 'tr']) : super(locale);

  @override
  String get back => 'Geri';

  @override
  String get cancel => 'İptal';

  @override
  String get close => 'Kapat';

  @override
  String get managed_error_content =>
      'Beklenmeyen bir hata oluştu. Bu hatayı zaten günlüğe kaydettik. Lütfen daha sonra tekrar deneyin.';

  @override
  String get managed_error_oops => 'Hata, bir şeyler yanlış gitti';

  @override
  String get no => 'Hayır';

  @override
  String get ok => 'Tamam';

  @override
  String get submit => 'Gönder';

  @override
  String get system_language => 'Sistem Dili';

  @override
  String get yes => 'Evet';
}
