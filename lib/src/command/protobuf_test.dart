import 'package:flutter_test/flutter_test.dart';
import '../../mock/protobuf/sample_service.pb.dart';
import '../../mock/protobuf/echo_request.pbserver.dart';
import 'package:libcli/command.dart' as command;

void main() {
  var service = SampleService();
  group('[command-protobuf]', () {
    test('should encode ProtoObject', () {
      EchoAction echoAction = EchoAction();
      echoAction.text = 'hi';
      List<int> bytes = command.encode(echoAction);
      expect(bytes.length, 6);
    });

    test('should decode ProtoObject', () {
      EchoAction echoAction = EchoAction();
      echoAction.text = 'hi';
      List<int> bytes = command.encode(echoAction);
      EchoAction decodeAction = command.decode(bytes, service) as EchoAction;
      expect(decodeAction.text, 'hi');
    });

    test('should decode fail when id is wrong', () {
      EchoAction echoAction = EchoAction();
      echoAction.text = 'hi';
      List<int> bytes = command.encode(echoAction);
      bytes[bytes.length - 1] = 255;
      expect(() => command.decode(bytes, service), throwsException);
    });
  });
}
