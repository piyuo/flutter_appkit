import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/utils.dart' as utils;

void main() {
  group('[utils]', () {
    test('should get uuid', () {
      String i = utils.uuid();
      expect(i.length > 0, true);
    });

    test('should check internet connected', () async {
      bool result = await utils.isInternetConnected();
      expect(result, true);
    });
  });
}
