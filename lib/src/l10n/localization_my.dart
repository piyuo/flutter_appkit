// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class LocalizationMy extends Localization {
  LocalizationMy([String locale = 'my']) : super(locale);

  @override
  String get close => 'ပိတ်ရန်';

  @override
  String get error_content =>
      'မမျှော်လင့်ထားသော အမှားတစ်ခု ဖြစ်ပွားခဲ့သည်။ ကျွန်ုပ်တို့သည် ဤအမှားကို ရှိပြီးမှ မှတ်တမ်းတင်ထားပါသည်။ ကျေးဇူးပြု၍ နောက်မှ ထပ်မံကြိုးစားပါ။';

  @override
  String get error_oops => 'အို၊ တစ်ခုခုမှားယွင်းသွားပါပြီ';

  @override
  String get language => 'စစ်စဉ်ဘာသာ';
}
