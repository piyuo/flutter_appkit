import 'package:flutter_test/flutter_test.dart';
import 'dialog.dart';

void main() {
  setUp(() async {});

  group('[dialog]', () {
    test('should init', () async {
      var dialogProvider = DialogProvider();
      expect(dialogProvider.init(), isNotNull);
    });
  });
}
