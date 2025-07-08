// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class LocalizationPt extends Localization {
  LocalizationPt([String locale = 'pt']) : super(locale);

  @override
  String get back => 'Voltar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Fechar';

  @override
  String get managed_error_content =>
      'Ocorreu um erro inesperado. Já registramos este erro. Por favor, tente novamente mais tarde.';

  @override
  String get managed_error_oops => 'Ops, algo deu errado';

  @override
  String get no => 'Não';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Enviar';

  @override
  String get system_language => 'Língua do sistema';

  @override
  String get yes => 'Sim';
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class LocalizationPtPt extends LocalizationPt {
  LocalizationPtPt() : super('pt_PT');

  @override
  String get back => 'Voltar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Fechar';

  @override
  String get managed_error_content =>
      'Ocorreu um erro inesperado. Já registámos este erro. Por favor, tente novamente mais tarde.';

  @override
  String get managed_error_oops => 'Ups, algo correu mal';

  @override
  String get no => 'Não';

  @override
  String get ok => 'OK';

  @override
  String get submit => 'Submeter';

  @override
  String get system_language => 'Língua do sistema';

  @override
  String get yes => 'Sim';
}
