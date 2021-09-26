import 'package:flutter_test/flutter_test.dart';
import 'storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('[storage]', () {
    test('should set/get item', () async {
      await setItem('item1', {'cleaning': 'done'});
      var item1 = await getItem('item1');
      expect(item1!['cleaning'], 'done');
      await delete('item1');
      var title2 = await getItem('item1');
      expect(title2, isNull);
      await clear();
    });
  });
}
