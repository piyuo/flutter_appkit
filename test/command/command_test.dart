import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:http/testing.dart';
import '../mock/protobuf/sys_service.pb.dart';
import '../mock/protobuf/string_response.pbserver.dart';
import '../mock/protobuf/echo_action.pbserver.dart';
import 'package:libcli/command/commands/shared/ping_action.pb.dart';
import 'package:libcli/command/command_protobuf.dart' as commandProtobuf;
import 'package:http/http.dart' as http;

void main() {
  group('command', () {
    test('should send command and receive response', () async {
      var client = MockClient((request) async {
        StringResponse sr = StringResponse();
        sr.text = 'hi';
        List<int> bytes = commandProtobuf.encode(sr);
        return http.Response.bytes(bytes, 200);
      });

      SysService service = SysService();
      EchoAction action = new EchoAction();
      var response = await service.requestWithClient(client, action);
      expect(response.ok, true);
      expect((response.data as StringResponse).text, 'hi');
    });

    test('should receive null', () async {
      var client = MockClient((request) async {
        return http.Response('', 501);
      });
      SysService service = SysService();
      EchoAction action = new EchoAction();
      var response = await service.requestWithClient(client, action);
      expect(response.ok, false);
    });

    test('should send command to test server and receive response', () async {
      app.branch = app.Branch.test;
      SysService service = SysService();
      PingAction action = new PingAction();
      var response = await service.request(action);
      expect(response, isNotNull);
      expect(response.ok, true);
    });
    test('should return null when send wrong action to test server', () async {
      app.branch = app.Branch.test;
      SysService service = SysService();
      EchoAction action = new EchoAction();
      var response = await service.request(action);
      expect(response.ok, false);
      expect(response.data, null);
    });
  });
}
