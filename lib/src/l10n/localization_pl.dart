// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class LocalizationPl extends Localization {
  LocalizationPl([String locale = 'pl']) : super(locale);

  @override
  String get close => 'Zamknij';

  @override
  String get error_content =>
      'Wystąpił nieoczekiwany błąd. Już zalogowaliśmy ten błąd. Spróbuj ponownie później.';

  @override
  String get error_oops => 'Ups, coś poszło nie tak';

  @override
  String get language => 'Język systemu';
}
