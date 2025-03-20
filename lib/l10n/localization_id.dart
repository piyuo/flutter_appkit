// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class LocalizationId extends Localization {
  LocalizationId([String locale = 'id']) : super(locale);

  @override
  String get cli_error_oops => 'Ups, terjadi kesalahan';

  @override
  String get cli_error_content => 'Terjadi kesalahan yang tidak terduga. Apakah Anda ingin mengirimkan laporan email?';

  @override
  String get cli_error_report => 'Email kami';

  @override
  String get submit => 'Kirim';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Batal';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get close => 'Tutup';

  @override
  String get back => 'Kembali';
}
