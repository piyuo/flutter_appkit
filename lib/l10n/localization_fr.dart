// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class LocalizationFr extends Localization {
  LocalizationFr([String locale = 'fr']) : super(locale);

  @override
  String get back => 'Retour';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get managed_error_content =>
      'Une erreur inattendue s\'est produite. Nous avons déjà enregistré cette erreur. Veuillez réessayer plus tard.';

  @override
  String get managed_error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Envoyer';

  @override
  String get system_language => 'Langue du système';

  @override
  String get yes => 'Oui';
}

/// The translations for French, as used in Belgium (`fr_BE`).
class LocalizationFrBe extends LocalizationFr {
  LocalizationFrBe() : super('fr_BE');

  @override
  String get back => 'Retour';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get managed_error_content =>
      'Une erreur inattendue s\'est produite. Nous avons déjà enregistré cette erreur. Veuillez réessayer plus tard.';

  @override
  String get managed_error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Envoyer';

  @override
  String get system_language => 'Langue du système';

  @override
  String get yes => 'Oui';
}

/// The translations for French, as used in Canada (`fr_CA`).
class LocalizationFrCa extends LocalizationFr {
  LocalizationFrCa() : super('fr_CA');

  @override
  String get back => 'Retour';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get managed_error_content =>
      'Une erreur inattendue est survenue. Nous avons déjà enregistré cette erreur. Veuillez réessayer plus tard.';

  @override
  String get managed_error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Soumettre';

  @override
  String get system_language => 'Langue du système';

  @override
  String get yes => 'Oui';
}

/// The translations for French, as used in Switzerland (`fr_CH`).
class LocalizationFrCh extends LocalizationFr {
  LocalizationFrCh() : super('fr_CH');

  @override
  String get back => 'Retour';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get managed_error_content =>
      'Une erreur inattendue s\'est produite. Nous avons déjà enregistré cette erreur. Veuillez réessayer plus tard.';

  @override
  String get managed_error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Envoyer';

  @override
  String get system_language => 'Langue du système';

  @override
  String get yes => 'Oui';
}
