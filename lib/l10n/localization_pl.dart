// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class LocalizationPl extends Localization {
  LocalizationPl([String locale = 'pl']) : super(locale);

  @override
  String get back => 'Wstecz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get close => 'Zamknij';

  @override
  String get managed_error_content =>
      'Wystąpił nieoczekiwany błąd. Już zalogowaliśmy ten błąd. Spróbuj ponownie później.';

  @override
  String get managed_error_oops => 'Ups, coś poszło nie tak';

  @override
  String get no => 'Nie';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Wyślij';

  @override
  String get system_language => 'Język systemu';

  @override
  String get yes => 'Tak';
}
