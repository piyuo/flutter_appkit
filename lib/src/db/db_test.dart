import 'package:flutter_test/flutter_test.dart';
import 'db.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('[db]', () {
    test('should get/set obj', () async {
      collection('todo').doc('t1').set({'title': 'Todo title', 'done': false});
      final t1 = await collection('todo').doc('t1').get();
      expect(t1, isNotNull);
      expect(t1!['title'], 'Todo title');
      expect(t1['done'], false);

      // not stable now
      //await collection('todo').doc('t1').delete();
      //final t2 = await collection('todo').doc('t1').get();
      //expect(t2, isNull);
    });
  });
}
