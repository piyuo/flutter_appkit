// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class LocalizationFr extends Localization {
  LocalizationFr([String locale = 'fr']) : super(locale);

  @override
  String get cli_error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get cli_error_content => 'Une erreur inattendue s\'est produite. Souhaitez-vous envoyer un rapport par email ?';

  @override
  String get cli_error_report => 'Nous contacter par email';

  @override
  String get submit => 'Envoyer';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';

  @override
  String get system_language => 'Langue du système';
}

/// The translations for French, as used in Belgium (`fr_BE`).
class LocalizationFrBe extends LocalizationFr {
  LocalizationFrBe(): super('fr_BE');

  @override
  String get cli_error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get cli_error_content => 'Une erreur inattendue s\'est produite. Souhaitez-vous envoyer un rapport par e-mail ?';

  @override
  String get cli_error_report => 'Nous contacter par e-mail';

  @override
  String get submit => 'Envoyer';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';

  @override
  String get system_language => 'Langue du système';
}

/// The translations for French, as used in Canada (`fr_CA`).
class LocalizationFrCa extends LocalizationFr {
  LocalizationFrCa(): super('fr_CA');

  @override
  String get cli_error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get cli_error_content => 'Une erreur inattendue est survenue. Souhaitez-vous envoyer un rapport par courriel ?';

  @override
  String get cli_error_report => 'Nous contacter par courriel';

  @override
  String get submit => 'Soumettre';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';

  @override
  String get system_language => 'Langue du système';
}

/// The translations for French, as used in Switzerland (`fr_CH`).
class LocalizationFrCh extends LocalizationFr {
  LocalizationFrCh(): super('fr_CH');

  @override
  String get cli_error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get cli_error_content => 'Une erreur inattendue s\'est produite. Souhaitez-vous envoyer un rapport par e-mail ?';

  @override
  String get cli_error_report => 'Nous contacter par e-mail';

  @override
  String get submit => 'Envoyer';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';

  @override
  String get system_language => 'Langue du système';
}
