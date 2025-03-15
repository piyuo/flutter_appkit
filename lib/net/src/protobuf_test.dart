// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;

import 'protobuf.dart';

void main() {
  group('[net.protobuf]', () {
    test('should encode Object', () {
      sample.EchoAction echoAction = sample.EchoAction();
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
      sample.EchoAction echoAction = sample.EchoAction();
      echoAction.value = 'hi';
      List<int> bytes = encode(echoAction);
      bytes[bytes.length - 1] = 255;
      expect(() => decode(bytes, () => sample.StringResponse()), throwsException);
    });
  });
}
