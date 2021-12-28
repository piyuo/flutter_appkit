import 'package:intl/intl.dart';
import 'package:libcli/pb/src/object.dart';

/// standardDateFormat return internal use standard date format like '1999-01-11 23:22:02'
DateFormat get standardDateFormat {
  return DateFormat("yyyy-MM-dd HH:mm:ss");
}

/// formatDate convert date time to standard date format
///
///      var str = formatDate(date);
///      expect(str, '2021-01-02 23:30:00Z');
///
String formatDate(DateTime date) {
  return standardDateFormat.format(date) + (date.isUtc ? 'Z' : '');
}

/// parseDate parse standard date format string to date
///
///     final date = parseDate('2021-01-02 23:30:00Z');
///     expect(date.year, 2021);
///
DateTime parseDate(String date) {
  if (date[date.length - 1] == 'Z') {
    date = date.substring(0, date.length - 1);
    return standardDateFormat.parseUTC(date);
  }
  return standardDateFormat.parse(date);
}

/// formatObject convert object to string format
///
///      var str = formatObject(Error());
///
String formatObject(Object obj) => obj.toBase64();

/// parseObject parse object format string to object
///
///     final obj = parseObject('CgJoaQ==', Error());
///
T parseObject<T extends Object>(String str, T obj) => obj..fromBase64(str);

/// formatObjectList convert object list to string format
///
///     final list = [Error()..code = 'hello', Error()..code = 'world'];
///     List<String> strList = formatObjectList(list);
///
List<String> formatObjectList(List<Object> src) {
  final list = <String>[];
  for (final item in src) {
    list.add(item.toBase64());
  }
  return list;
}

/// parseObject parse object format string list to object
///
///     final list2 = parseObjectList(strList, () => Error());
///
List<T> parseObjectList<T extends Object>(List<String> src, Factory<T> builder) {
  final list = <T>[];
  for (final item in src) {
    final obj = builder();
    obj.fromBase64(item);
    list.add(obj);
  }
  return list;
}
