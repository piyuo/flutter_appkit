import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/dialog/dialog.dart';

void main() {
  setUp(() async {});

  group('[dialog]', () {
    test('should init', () async {
      var builder = init();
      expect(builder, isNotNull);
    });
  });
}
