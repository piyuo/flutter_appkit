// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class LocalizationId extends Localization {
  LocalizationId([String locale = 'id']) : super(locale);

  @override
  String get close => 'Tutup';

  @override
  String get error_content =>
      'Terjadi kesalahan yang tidak terduga. Kami sudah mencatat kesalahan ini. Silakan coba lagi nanti.';

  @override
  String get error_oops => 'Ups, terjadi kesalahan';

  @override
  String get language => 'Bahasa Sistem';
}
