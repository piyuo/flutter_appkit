// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class LocalizationMy extends Localization {
  LocalizationMy([String locale = 'my']) : super(locale);

  @override
  String get cli_error_oops => 'အို၊ တစ်ခုခုမှားယွင်းသွားပါပြီ';

  @override
  String get cli_error_content => 'မမျှော်လင့်ထားသော အမှားတစ်ခု ဖြစ်ပွားခဲ့သည်။ အီးမေးလ်အစီရင်ခံစာ ပေးပို့လိုပါသလား။';

  @override
  String get cli_error_report => 'ကျွန်ုပ်တို့ထံ အီးမေးလ်ပို့ပါ';

  @override
  String get submit => 'ပေးပို့ရန်';

  @override
  String get ok => 'အိုကေ';

  @override
  String get cancel => 'ပယ်ဖျက်ရန်';

  @override
  String get yes => 'ဟုတ်ကဲ့';

  @override
  String get no => 'မဟုတ်ပါ';

  @override
  String get close => 'ပိတ်ရန်';

  @override
  String get back => 'နောက်သို့';

  @override
  String get system_language => 'စစ်စဉ်ဘာသာ';
}
