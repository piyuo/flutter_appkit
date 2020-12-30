import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/mock/protobuf/sample_service.pb.dart';
import 'package:libcli/mock/protobuf/command-echo.pbserver.dart';
import 'package:libcli/command.dart' as command;

void main() {
  var service = SampleService();
  group('[command-protobuf]', () {
    test('should encode ProtoObject', () {
      CommandEcho echoAction = CommandEcho();
      echoAction.value = 'hi';
      List<int> bytes = command.encode(echoAction);
      expect(bytes.length, 6);
    });

    test('should decode ProtoObject', () {
      CommandEcho echoAction = CommandEcho();
      echoAction.value = 'hi';
      List<int> bytes = command.encode(echoAction);
      CommandEcho decodeAction = command.decode(bytes, service) as CommandEcho;
      expect(decodeAction.value, 'hi');
    });

    test('should decode fail when id is wrong', () {
      CommandEcho echoAction = CommandEcho();
      echoAction.value = 'hi';
      List<int> bytes = command.encode(echoAction);
      bytes[bytes.length - 1] = 255;
      expect(() => command.decode(bytes, service), throwsException);
    });
  });
}
