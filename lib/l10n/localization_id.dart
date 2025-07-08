// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class LocalizationId extends Localization {
  LocalizationId([String locale = 'id']) : super(locale);

  @override
  String get back => 'Kembali';

  @override
  String get cancel => 'Batal';

  @override
  String get close => 'Tutup';

  @override
  String get managed_error_content =>
      'Terjadi kesalahan yang tidak terduga. Kami sudah mencatat kesalahan ini. Silakan coba lagi nanti.';

  @override
  String get managed_error_oops => 'Ups, terjadi kesalahan';

  @override
  String get no => 'Tidak';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Kirim';

  @override
  String get system_language => 'Bahasa Sistem';

  @override
  String get yes => 'Ya';
}
