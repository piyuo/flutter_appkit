import 'package:flutter_test/flutter_test.dart';
import 'storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('[storage]', () {
    test('should get/set obj', () async {
      Storage storage = Storage('todo.json');
      await storage.set('item1', {'cleaning': 'done'});
      var item1 = await storage.get('item1');
      expect(item1!['cleaning'], 'done');
      await storage.delete('item1');
      var title2 = await storage.get('item1');
      expect(title2, isNull);
      await storage.clear();
    });
  });
}
