import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/utils/net.dart';

void main() {
  group('[utils/net]', () {
    test('should check internet connected', () async {
      bool result = await isInternetConnected();
      expect(result, true);
    });
  });
}
