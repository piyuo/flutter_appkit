// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class LocalizationTr extends Localization {
  LocalizationTr([String locale = 'tr']) : super(locale);

  @override
  String get close => 'Kapat';

  @override
  String get error_content =>
      'Beklenmeyen bir hata oluştu. Gelişmemize yardımcı olmak için bize rapor gönderebilirsiniz veya daha sonra tekrar deneyebilirsiniz.';

  @override
  String get error_oops => 'Hata, bir şeyler yanlış gitti';

  @override
  String get error_report_anonymously =>
      'Anonim rapor göndererek gelişmemize yardımcı olun';

  @override
  String get language => 'Sistem Dili';
}
