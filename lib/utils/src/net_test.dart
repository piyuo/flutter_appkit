// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'net.dart';

void main() {
  group('[utils/net]', () {
    test('should check internet connected', () async {
      bool result = await isInternetConnected();
      expect(result, true);
    });
  });
}
