// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class LocalizationDa extends Localization {
  LocalizationDa([String locale = 'da']) : super(locale);

  @override
  String get cli_error_oops => 'Ups, noget gik galt';

  @override
  String get cli_error_content => 'Der opstod en uventet fejl. Vil du indsende en e-mailrapport?';

  @override
  String get cli_error_report => 'Send os en e-mail';

  @override
  String get submit => 'Indsend';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuller';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nej';

  @override
  String get close => 'Luk';

  @override
  String get back => 'Tilbage';
}
