// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class LocalizationMs extends Localization {
  LocalizationMs([String locale = 'ms']) : super(locale);

  @override
  String get back => 'Kembali';

  @override
  String get cancel => 'Batal';

  @override
  String get close => 'Tutup';

  @override
  String get managed_error_content =>
      'Ralat tidak dijangka telah berlaku. Kami telah mencatat ralat ini. Sila cuba lagi nanti.';

  @override
  String get managed_error_oops => 'Alamak, ada sesuatu yang tidak kena';

  @override
  String get no => 'Tidak';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Hantar';

  @override
  String get system_language => 'Bahasa Sistem';

  @override
  String get yes => 'Ya';
}

/// The translations for Malay, as used in Singapore (`ms_SG`).
class LocalizationMsSg extends LocalizationMs {
  LocalizationMsSg() : super('ms_SG');

  @override
  String get back => 'Kembali';

  @override
  String get cancel => 'Batal';

  @override
  String get close => 'Tutup';

  @override
  String get managed_error_content =>
      'Ralat tidak dijangka telah berlaku. Kami telah mencatat ralat ini. Sila cuba lagi nanti.';

  @override
  String get managed_error_oops => 'Alamak, ada sesuatu yang tidak betul';

  @override
  String get no => 'Tidak';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Hantar';

  @override
  String get system_language => 'Bahasa Sistem';

  @override
  String get yes => 'Ya';
}
