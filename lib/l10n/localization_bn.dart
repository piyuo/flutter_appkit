// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class LocalizationBn extends Localization {
  LocalizationBn([String locale = 'bn']) : super(locale);

  @override
  String get cli_error_oops => 'উফ, কিছু একটা ভুল হয়েছে';

  @override
  String get cli_error_content =>
      'একটি অপ্রত্যাশিত ত্রুটি ঘটেছে। আপনি কি একটি ইমেল রিপোর্ট জমা দিতে চান?';

  @override
  String get cli_error_report => 'আমাদের ইমেল করুন';

  @override
  String get submit => 'জমা দিন';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get cancel => 'বাতিল';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get back => 'পিছনে';

  @override
  String get system_language => 'সিস্টেম ভাষা';
}

/// The translations for Bengali Bangla, as used in India (`bn_IN`).
class LocalizationBnIn extends LocalizationBn {
  LocalizationBnIn() : super('bn_IN');

  @override
  String get cli_error_oops => 'ওহো, কিছু একটা ভুল হয়েছে';

  @override
  String get cli_error_content =>
      'একটি অপ্রত্যাশিত ত্রুটি ঘটেছে। আপনি কি একটি ইমেল রিপোর্ট পাঠাতে চান?';

  @override
  String get cli_error_report => 'আমাদের ইমেল করুন';

  @override
  String get submit => 'জমা দিন';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get cancel => 'বাতিল';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get back => 'পিছনে';

  @override
  String get system_language => 'সিস্টেম ভাষা';
}
