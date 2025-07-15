// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class LocalizationMr extends Localization {
  LocalizationMr([String locale = 'mr']) : super(locale);

  @override
  String get close => 'बंद करा';

  @override
  String get error_content =>
      'अनपेक्षित त्रुटी आली. आम्हाला सुधारण्यास मदत करण्यासाठी तुम्ही आम्हाला अहवाल पाठवू शकता, किंवा नंतर पुन्हा प्रयत्न करू शकता.';

  @override
  String get error_oops => 'अरेरे, काहीतरी चूक झाली';

  @override
  String get error_report_anonymously =>
      'अज्ञात अहवाल पाठवून आम्हाला सुधारण्यास मदत करा';

  @override
  String get language => 'प्रणाली भाषा';
}
