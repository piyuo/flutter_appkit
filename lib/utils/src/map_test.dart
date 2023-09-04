import 'package:flutter_test/flutter_test.dart';
import 'map.dart';

void main() {
  setUp(() async {});

  group('[map]', () {
    test('should deep copy', () async {
      Map map = {
        'value': 2,
        'child': {'text': 'hi'}
      };

      Map newMap = map.deepCopy();
      expect(newMap['value'], 2);
      expect(newMap['child']['text'], 'hi');

      newMap['child']['text'] = 'changed';
      expect(map['child']['text'], 'hi');
    });

    test('should clone new map', () async {
      Map<String, int> map = {
        'a': 1,
        'b': 2,
      };

      final newMap = map.clone();
      expect(newMap['a'], 1);
      expect(newMap['b'], 2);
    });
  });
}
