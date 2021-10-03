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
  });
}
