import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/command/src/protobuf.dart';

void main() {
  group('[command_protobuf]', () {
    test('should encode Object', () {
      sample.CmdEcho echoAction = sample.CmdEcho();
      echoAction.value = 'hi';
      List<int> bytes = encode(echoAction);
      expect(bytes.length, 6);
    });

    test('should decode Object', () {
      sample.StringResponse response = sample.StringResponse();
      response.value = 'hi';
      List<int> bytes = encode(response);
      sample.StringResponse decodeAction = decode(bytes, () => sample.StringResponse()) as sample.StringResponse;
      expect(decodeAction.value, 'hi');
    });

    test('should decode fail when id is wrong', () {
      sample.CmdEcho echoAction = sample.CmdEcho();
      echoAction.value = 'hi';
      List<int> bytes = encode(echoAction);
      bytes[bytes.length - 1] = 255;
      expect(() => decode(bytes, () => sample.StringResponse()), throwsException);
    });
  });
}
