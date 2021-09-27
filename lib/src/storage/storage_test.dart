import 'package:flutter_test/flutter_test.dart';
import 'storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('[storage]', () {
    test('should set/get JSON', () async {
      await setJSON('item1', {'cleaning': 'done'});
      var item1 = await getJSON('item1');
      expect(item1!['cleaning'], 'done');
      await delete('item1');
      var item2 = await getJSON('item1');
      expect(item2, isNull);
      await clear();
    });

    test('should set/get string', () async {
      await setString('item1', 'hi');
      var str1 = await getString('item1');
      expect(str1, 'hi');
      await delete('item1');
      var str2 = await getString('item1');
      expect(str2, isNull);
      await clear();
    });

    test('should set/get string list', () async {
      await setStringList('item1', ['hello', 'world']);
      var list = await getStringList('item1');
      expect(list!.length, 2);
      await delete('item1');
      var str2 = await getStringList('item1');
      expect(str2, isNull);
      await clear();
    });
  });
}
