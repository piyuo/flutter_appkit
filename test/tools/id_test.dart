import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/tools/id.dart' as id;

void main() {
  group('[tools_id]', () {
    test('should get uuid', () {
      String i = id.uuid();
      expect(i.length > 0, true);
    });
  });
}
