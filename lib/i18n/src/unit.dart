import 'package:intl/intl.dart';

/// metersToKmOrMiles convert meters to km or miles base on system locale
String metersToKmOrMiles(double meters) {
  final locale = Intl.getCurrentLocale();
  if (locale.toString() == 'en_US') {
    return '${(meters / 1609.344).toStringAsFixed(2)} miles';
  }
  return '${(meters / 1000).toStringAsFixed(2)} km';
}
