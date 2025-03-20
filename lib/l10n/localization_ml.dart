// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class LocalizationMl extends Localization {
  LocalizationMl([String locale = 'ml']) : super(locale);

  @override
  String get cli_error_oops => 'അയ്യോ, എന്തോ തെറ്റ് സംഭവിച്ചു';

  @override
  String get cli_error_content => 'അപ്രതീക്ഷിതമായ ഒരു പിശക് സംഭവിച്ചു. ഇമെയിൽ റിപ്പോർട്ട് സമർപ്പിക്കാൻ നിങ്ങൾ ആഗ്രഹിക്കുന്നുണ്ടോ?';

  @override
  String get cli_error_report => 'ഞങ്ങൾക്ക് ഇമെയിൽ ചെയ്യുക';

  @override
  String get submit => 'സമർപ്പിക്കുക';

  @override
  String get ok => 'ശരി';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get yes => 'അതെ';

  @override
  String get no => 'അല്ല';

  @override
  String get close => 'അടയ്ക്കുക';

  @override
  String get back => 'തിരികെ';
}
