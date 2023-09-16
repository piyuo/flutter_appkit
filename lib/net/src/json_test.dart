import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/common/common.dart' as common;
import 'package:libcli/net/net.dart' as net;

void main() {
  group('[net.json]', () {
    test('should use standard format', () async {
      // utc
      var date = DateTime(2021, 1, 2, 23, 30);
      var str = net.formatDate(date);
      expect(str, '2021-01-02 23:30:00');
      var date2 = net.parseDate(str);
      expect(date2, date);
    });

    test('should use utc standard format', () async {
      // utc
      var date = DateTime.utc(2021, 1, 2, 23, 30);
      var str = net.formatDate(date);
      expect(str, '2021-01-02 23:30:00Z');
      var date2 = net.parseDate(str);
      expect(date2, date);
    });

    test('should stringify object', () async {
      final obj = common.Error()..code = 'hi';
      String str = net.formatObject(obj);
      expect(str, 'CgJoaQ==');

      final obj2 = net.parseObject(str, common.Error());
      expect(obj.code, obj2.code);
    });

    test('should stringify object list', () async {
      final list = [common.Error()..code = 'hello', common.Error()..code = 'world'];
      List<String> strList = net.formatObjectList(list);
      expect(strList.length, 2);

      final list2 = net.parseObjectList(strList, () => common.Error());
      expect(list[0].code, list2[0].code);
      expect(list[0].code, list2[0].code);
    });
  });
}
