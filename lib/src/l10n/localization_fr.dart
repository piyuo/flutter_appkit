// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class LocalizationFr extends Localization {
  LocalizationFr([String locale = 'fr']) : super(locale);

  @override
  String get close => 'Fermer';

  @override
  String get error_content =>
      'Une erreur inattendue s\'est produite. Vous pouvez nous envoyer un rapport pour nous aider à nous améliorer, ou réessayer plus tard.';

  @override
  String get error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get error_report_anonymously =>
      'Aidez-nous à nous améliorer en envoyant un rapport anonyme';

  @override
  String get language => 'Langue du système';
}

/// The translations for French, as used in Belgium (`fr_BE`).
class LocalizationFrBe extends LocalizationFr {
  LocalizationFrBe() : super('fr_BE');

  @override
  String get close => 'Fermer';

  @override
  String get error_content =>
      'Une erreur inattendue s\'est produite. Vous pouvez nous envoyer un rapport pour nous aider à nous améliorer, ou réessayer plus tard.';

  @override
  String get error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get error_report_anonymously =>
      'Aidez-nous à nous améliorer en envoyant un rapport anonyme';

  @override
  String get language => 'Langue du système';
}

/// The translations for French, as used in Canada (`fr_CA`).
class LocalizationFrCa extends LocalizationFr {
  LocalizationFrCa() : super('fr_CA');

  @override
  String get close => 'Fermer';

  @override
  String get error_content =>
      'Une erreur inattendue est survenue. Vous pouvez nous envoyer un rapport pour nous aider à nous améliorer, ou réessayer plus tard.';

  @override
  String get error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get error_report_anonymously =>
      'Aidez-nous à améliorer en envoyant un rapport anonyme';

  @override
  String get language => 'Langue du système';
}

/// The translations for French, as used in Switzerland (`fr_CH`).
class LocalizationFrCh extends LocalizationFr {
  LocalizationFrCh() : super('fr_CH');

  @override
  String get close => 'Fermer';

  @override
  String get error_content =>
      'Une erreur inattendue s\'est produite. Vous pouvez nous envoyer un rapport pour nous aider à nous améliorer, ou réessayer plus tard.';

  @override
  String get error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get error_report_anonymously =>
      'Aidez-nous à nous améliorer en envoyant un rapport anonyme';

  @override
  String get language => 'Langue du système';
}
