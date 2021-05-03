import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/mock/protobuf/sample_service.pb.dart';
import 'package:libcli/mock/protobuf/command-echo.pbserver.dart';
import 'package:libcli/mock/protobuf/string-response.pbserver.dart';
import 'protobuf.dart';

void main() {
  var service = SampleService();
  group('[command-protobuf]', () {
    test('should encode Object', () {
      CommandEcho echoAction = CommandEcho();
      echoAction.value = 'hi';
      List<int> bytes = encode(echoAction);
      expect(bytes.length, 6);
    });

    test('should decode Object', () {
      StringResponse response = StringResponse();
      response.value = 'hi';
      List<int> bytes = encode(response);
      StringResponse decodeAction = decode(bytes, service) as StringResponse;
      expect(decodeAction.value, 'hi');
    });

    test('should decode fail when id is wrong', () {
      CommandEcho echoAction = CommandEcho();
      echoAction.value = 'hi';
      List<int> bytes = encode(echoAction);
      bytes[bytes.length - 1] = 255;
      expect(() => decode(bytes, service), throwsException);
    });
  });
}
