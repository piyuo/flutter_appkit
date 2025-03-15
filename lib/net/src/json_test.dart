// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/net/net.dart' as net;
import 'package:libcli/sample/sample.dart' as sample;

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
      final obj = sample.Person(name: 'hi');
      String str = net.formatObject(obj);
      expect(str, 'EgJoaQ==');

      final obj2 = net.parseObject(str, sample.Person());
      expect(obj.name, obj2.name);
    });

    test('should stringify object list', () async {
      final list = [sample.Person(name: 'hello'), sample.Person(name: 'world')];
      List<String> strList = net.formatObjectList(list);
      expect(strList.length, 2);

      final list2 = net.parseObjectList(strList, () => sample.Person());
      expect(list[0].name, list2[0].name);
      expect(list[0].name, list2[0].name);
    });
  });
}
