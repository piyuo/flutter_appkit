import 'package:intl/intl.dart';
import 'package:libcli/src/i18n/i18n.dart';

/// initDateFormatting will set by configuration
///
///     i18n.initDateFormatting();
///
//Function initDateFormatting;

/// withLocale run function in Intl zone
///
withLocale(Function() function) {
  Intl.withLocale(localeName, function);
}

/// timeToStr convert hour and minute to local string
///
///      var str = timeToStr(07, 30);
///      expect(str, '7:30 AM');
///
String fixedTimeToStr(int hour, int minute) {
  var date = DateTime.utc(2001, 1, 1, hour, minute);
  var str = '';
  withLocale(() {
    str = DateFormat.jm().format(date);
  });
  return str;
}

/// dateToStr convert date to local string
///
///     var str = dateToStr(date);
///     expect(str, 'Jan 2, 2021');
///
String dateToStr(DateTime date) {
  var str = '';
  withLocale(() {
    str = DateFormat.yMMMd().format(date);
  });
  return str;
}

/// datetimeToStr convert date and time to local string
///
///      var str = datetimeToStr(date);
///      expect(str, 'Jan 2, 2021 11:30 PM');
///
String datetimeToStr(DateTime date) {
  var str = '';
  withLocale(() {
    str = DateFormat.yMMMd().add_jm().format(date);
  });
  return str;
}

/// timeToStr convert time to local string
///
///     var str = timeToStr(date);
///     expect(str, '11:30 PM');
///
String timeToStr(DateTime date) {
  var str = '';
  withLocale(() {
    str = DateFormat.jm().format(date);
  });
  return str;
}
