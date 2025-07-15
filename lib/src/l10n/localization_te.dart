// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class LocalizationTe extends Localization {
  LocalizationTe([String locale = 'te']) : super(locale);

  @override
  String get close => 'మూసివేయి';

  @override
  String get error_content =>
      'ఊహించని లోపం సంభవించింది. మెరుగుపరచడంలో మాకు సహాయపడటానికి మీరు మాకు నివేదిక పంపవచ్చు, లేదా తర్వాత మళ్లీ ప్రయత్నించవచ్చు.';

  @override
  String get error_oops => 'అయ్యో, ఏదో తప్పు జరిగింది';

  @override
  String get error_report_anonymously =>
      'అజ్ఞాత నివేదిక పంపడం ద్వారా మెరుగుపరచడంలో మాకు సహాయపడండి';

  @override
  String get language => 'సిస్టం భాష';
}
