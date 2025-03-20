// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class LocalizationTe extends Localization {
  LocalizationTe([String locale = 'te']) : super(locale);

  @override
  String get cli_error_oops => 'అయ్యో, ఏదో తప్పు జరిగింది';

  @override
  String get cli_error_content => 'ఊహించని లోపం సంభవించింది. మీరు ఇమెయిల్ నివేదికను సమర్పించాలనుకుంటున్నారా?';

  @override
  String get cli_error_report => 'మాకు ఇమెయిల్ చేయండి';

  @override
  String get submit => 'సమర్పించు';

  @override
  String get ok => 'సరే';

  @override
  String get cancel => 'రద్దు చేయి';

  @override
  String get yes => 'అవును';

  @override
  String get no => 'కాదు';

  @override
  String get close => 'మూసివేయి';

  @override
  String get back => 'వెనుకకు';
}
