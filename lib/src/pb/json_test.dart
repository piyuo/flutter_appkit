import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/pb/simple/error.pb.dart';
import 'dart:convert';
import 'json.dart';

void main() {
  group('[object_json]', () {
    test('should use standard format', () async {
      // utc
      var date = DateTime(2021, 1, 2, 23, 30);
      var str = formatDate(date);
      expect(str, '2021-01-02 23:30:00');
      var date2 = parseDate(str);
      expect(date2, date);
    });

    test('should use utc standard format', () async {
      // utc
      var date = DateTime.utc(2021, 1, 2, 23, 30);
      var str = formatDate(date);
      expect(str, '2021-01-02 23:30:00Z');
      var date2 = parseDate(str);
      expect(date2, date);
    });

    test('should stringify object', () async {
      final obj = Error()..code = 'hi';
      String str = formatObject(obj);
      expect(str, 'CgJoaQ==');

      final obj2 = parseObject(str, Error());
      expect(obj.code, obj2.code);
    });

    test('should stringify object list', () async {
      final list = [Error()..code = 'hello', Error()..code = 'world'];
      List<String> strList = formatObjectList(list);
      expect(strList.length, 2);

      final list2 = parseObjectList(strList, () => Error());
      expect(list[0].code, list2[0].code);
      expect(list[0].code, list2[0].code);
    });
  });
}
