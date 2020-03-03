import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/tools/net.dart' as net;

void main() {
  group('[tools]', () {
    test('should check internet connected', () async {
      bool result = await net.isInternetConnected();
      expect(result, true);
    });

    //test('should check google cloud function available', () async {
    //bool result = await tools.isGoogleCloudFunctionAvailable();
    //expect(result, true);
    //});
  });
}
