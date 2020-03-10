import 'package:flutter_test/flutter_test.dart';
import '../mock/protobuf/sys_service.pb.dart';
import '../mock/protobuf/echo_request.pbserver.dart';
import 'package:libcli/command/command_protobuf.dart' as commandProtobuf;

void main() {
  var service = SysService();
  group('[command_protobuf_test]', () {
    test('should encode ProtoObject', () {
      EchoRequest echoAction = EchoRequest();
      echoAction.text = 'hi';
      List<int> bytes = commandProtobuf.encode(echoAction);
      expect(bytes.length, 6);
    });

    test('should decode ProtoObject', () {
      EchoRequest echoAction = EchoRequest();
      echoAction.text = 'hi';
      List<int> bytes = commandProtobuf.encode(echoAction);
      EchoRequest decodeAction = commandProtobuf.decode(bytes, service);
      expect(decodeAction.text, 'hi');
    });

    test('should decode fail when id is wrong', () {
      EchoRequest echoAction = EchoRequest();
      echoAction.text = 'hi';
      List<int> bytes = commandProtobuf.encode(echoAction);
      bytes[bytes.length - 1] = 255;
      try {
        commandProtobuf.decode(bytes, service);
        expect(1, 0); // this line should not be execute
      } on Exception catch (e) {
        expect(e != null, true);
      }
    });
  });
}
