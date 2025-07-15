// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class LocalizationMl extends Localization {
  LocalizationMl([String locale = 'ml']) : super(locale);

  @override
  String get close => 'അടയ്ക്കുക';

  @override
  String get error_content =>
      'അപ്രതീക്ഷിതമായ ഒരു പിശക് സംഭവിച്ചു. ഞങ്ങളെ മെച്ചപ്പെടുത്താൻ സഹായിക്കാനായി നിങ്ങൾക്ക് ഞങ്ങൾക്ക് ഒരു റിപ്പോർട്ട് അയയ്ക്കാം, അല്ലെങ്കിൽ പിന്നീട് വീണ്ടും ശ്രമിക്കാം.';

  @override
  String get error_oops => 'അയ്യോ, എന്തോ തെറ്റ് സംഭവിച്ചു';

  @override
  String get error_report_anonymously =>
      'അജ്ഞാത റിപ്പോർട്ട് അയച്ച് മെച്ചപ്പെടുത്താൻ ഞങ്ങളെ സഹായിക്കുക';

  @override
  String get language => 'സിസ്റ്റം ഭാഷ';
}
