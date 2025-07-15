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
      'Wystąpił nieoczekiwany błąd. Możesz wysłać nam raport, aby pomóc nam się poprawić, lub spróbować ponownie później.';

  @override
  String get error_oops => 'Ups, coś poszło nie tak';

  @override
  String get error_report_anonymously =>
      'Pomóż nam się poprawić, wysyłając anonimowy raport';

  @override
  String get language => 'Język systemu';
}
