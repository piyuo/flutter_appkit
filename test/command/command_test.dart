import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import '../mock/protobuf/sys_service.pb.dart';
import '../mock/protobuf/string_response.pbserver.dart';
import '../mock/protobuf/echo_request.pbserver.dart';
import 'package:libcli/command/commands/shared/ping_action.pb.dart';
import 'package:libcli/command/commands/shared/err.pb.dart';
import 'package:libcli/command/command_protobuf.dart' as commandProtobuf;
import 'package:http/http.dart' as http;
import 'package:libcli/command/command.dart' as command;
import 'package:libcli/hook/vars.dart' as vars;

void main() {
  command.mockInit();

  group('[command]', () {
    test('should send command and receive response', () async {
      var client = MockClient((request) async {
        StringResponse sr = StringResponse();
        sr.text = 'hi';
        List<int> bytes = commandProtobuf.encode(sr);
        return http.Response.bytes(bytes, 200);
      });

      SysService service = SysService();
      var response = await service.dispatchWithClient(EchoRequest(), client);
      expect(response.ok, true);
      expect((response.data as StringResponse).text, 'hi');
    });

    test('should receive null', () async {
      var client = MockClient((request) async {
        return http.Response('', 501);
      });
      SysService service = SysService();
      var response = await service.dispatchWithClient(EchoRequest(), client);
      expect(response.ok, false);
    });

    test('should send command to test server and receive response', () async {
      vars.Branch = vars.Branches.test;
      SysService service = SysService();
      var response = await service.dispatch(PingAction());
      expect(response, isNotNull);
      expect(response.ok, true);
    });
    test('should return null when send wrong action to test server', () async {
      vars.Branch = vars.Branches.test;
      SysService service = SysService();
      EchoRequest action = new EchoRequest();
      var response = await service.dispatch(action);
      expect(response.ok, false);
      expect(response.data, null);
    });

    test('should return ok when is not Err response', () async {
      var protoObject = StringResponse();
      var response = command.Response.from(protoObject);
      expect(response.ok, true);
      expect(response.data, protoObject);
    });

    test('should return error response', () async {
      var err = Err()
        ..code = 1
        ..msg = 'mock_error';
      var response = command.Response.from(err);
      expect(response.ok, false);
      expect(response.data is Err, true);
    });

    test('should return ok response', () async {
      var err = Err()..code = 0;
      var response = command.Response.from(err);
      expect(response.ok, true);
      expect(response.data is Err, true);
    });
  });
}
