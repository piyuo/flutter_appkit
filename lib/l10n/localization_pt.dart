// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class LocalizationPt extends Localization {
  LocalizationPt([String locale = 'pt']) : super(locale);

  @override
  String get cli_error_oops => 'Ops, algo deu errado';

  @override
  String get cli_error_content => 'Ocorreu um erro inesperado. Gostaria de enviar um relatório por e-mail?';

  @override
  String get cli_error_report => 'Enviar e-mail';

  @override
  String get submit => 'Enviar';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';

  @override
  String get system_language => 'Língua do sistema';
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class LocalizationPtPt extends LocalizationPt {
  LocalizationPtPt(): super('pt_PT');

  @override
  String get cli_error_oops => 'Ups, algo correu mal';

  @override
  String get cli_error_content => 'Ocorreu um erro inesperado. Pretende enviar um relatório por e-mail?';

  @override
  String get cli_error_report => 'Enviar-nos e-mail';

  @override
  String get submit => 'Submeter';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';

  @override
  String get system_language => 'Língua do sistema';
}
