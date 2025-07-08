// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class LocalizationTe extends Localization {
  LocalizationTe([String locale = 'te']) : super(locale);

  @override
  String get back => 'వెనుకకు';

  @override
  String get cancel => 'రద్దు చేయి';

  @override
  String get close => 'మూసివేయి';

  @override
  String get managed_error_content =>
      'ఊహించని లోపం సంభవించింది. మేము ఈ లోపాన్ని ఇప్పటికే లాగ్ చేసాము. దయచేసి తర్వాత మళ్లీ ప్రయత్నించండి.';

  @override
  String get managed_error_oops => 'అయ్యో, ఏదో తప్పు జరిగింది';

  @override
  String get no => 'కాదు';

  @override
  String get ok => 'సరే';

  @override
  String get submit => 'సమర్పించు';

  @override
  String get system_language => 'సిస్టం భాష';

  @override
  String get yes => 'అవును';
}
