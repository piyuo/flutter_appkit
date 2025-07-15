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
      'မမျှော်လင့်ထားသော အမှားတစ်ခု ဖြစ်ပွားခဲ့သည်။ ကျွန်ုပ်တို့အား တိုးတက်စေရန် ကူညီရန်အတွက် အစီရင်ခံစာ ပို့နိုင်သည်၊ သို့မဟုတ် နောက်မှ ထပ်မံကြိုးစားပါ။';

  @override
  String get error_oops => 'အို၊ တစ်ခုခုမှားယွင်းသွားပါပြီ';

  @override
  String get error_report_anonymously =>
      'အမည်မသိ အစီရင်ခံစာ ပို့ခြင်းဖြင့် ကျွန်ုပ်တို့အား တိုးတက်စေရန် ကူညီပါ';

  @override
  String get language => 'စစ်စဉ်ဘာသာ';
}
