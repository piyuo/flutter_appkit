import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/util/id.dart';

void main() {
  group('[utils/id]', () {
    test('should get uuid', () {
      String i = uuid();
      expect(i.length > 0, true);
    });
  });
}
