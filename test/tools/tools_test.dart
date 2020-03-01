import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/tools/tools.dart' as tools;

void main() {
  group('tools', () {
    test('should get uuid', () {
      String id = tools.uuid();
      expect(id.length > 0, true);
    });

    test('should check internet connected', () async {
      bool result = await tools.isInternetConnected();
      expect(result, true);
    });

    //test('should check google cloud function available', () async {
    //bool result = await tools.isGoogleCloudFunctionAvailable();
    //expect(result, true);
    //});
  });
}
