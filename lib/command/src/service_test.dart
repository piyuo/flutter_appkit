import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/mock/protobuf/string-response.pbserver.dart';
import 'package:libcli/mock/protobuf/cmd-echo.pbserver.dart';
import 'package:libcli/mock/protobuf/sample-service.pb.dart';
import 'package:libcli/command/src/test.dart';
import 'package:libcli/command/src/protobuf.dart';
import 'package:libcli/command/src/firewall.dart';

void main() {
  dynamic lastEvent;
  eventbus.listen<FirewallBlockEvent>((BuildContext ctx, event) async {
    lastEvent = event;
  });

  setUp(() {
    lastEvent = null;
  });

  group('[command]', () {
    test('should send command and receive response', () async {
      var client = MockClient((request) async {
        StringResponse sr = StringResponse();
        sr.value = 'hi';
        List<int> bytes = encode(sr);
        return http.Response.bytes(bytes, 200);
      });
      SampleService service = SampleService();
      var response = await service.executeWithClient(testing.Context(), CmdEcho()..value = 'hello', client);
      expect(response is StringResponse, true);
      if (response is StringResponse) {
        expect(response.value, 'hi');
      }
    });

    test('should receive empty', () async {
      var client = MockClient((request) async {
        return http.Response('', 501);
      });
      MockService service = MockService();
      var response = await service.executeWithClient(testing.Context(), CmdEcho(), client);
      expect(response is pb.Empty, true);
    });

    test('should return null when send wrong action to test server', () async {
      // ignore: invalid_use_of_visible_for_testing_member
      app.branch = app.branchMaster;
      var service = MockService(mockExecute: (ctx, action) async {
        throw Exception('mock');
      });
      CmdEcho action = CmdEcho();
      expect(() async {
        await service.execute(testing.Context(), action);
      }, throwsException);
    });

    test('should mock execute', () async {
      var service = MockService(mockExecute: (ctx, action) async {
        return StringResponse()..value = 'hi';
      });

      CmdEcho action = CmdEcho();
      var response = await service.execute(testing.Context(), action);
      expect(response is StringResponse, true);
      if (response is StringResponse) {
        expect(response.value, 'hi');
      }
    });

    test('should use shared object', () async {
      var service = MockService(mockExecute: (ctx, action) async {
        return StringResponse()..value = 'hi';
      });

      CmdEcho action = CmdEcho();
      var response = await service.execute(testing.Context(), action);
      expect(response is StringResponse, true);
    });

    test('debugPort should return local test url', () async {
      MockService service = MockService();
      service.debugPort = 3001;
      expect(service.url, 'http://localhost:3001');
    });

    test('should block by firewall', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(encode(StringResponse()..value = 'hi'), 200);
      });
      SampleService service = SampleService();

      final cmd = CmdEcho(value: 'firewallBlock');
      mockFirewallInFlight(cmd.jsonString);

      var response = await service.executeWithClient(testing.Context(), cmd, client);
      expect(response is FirewallBlock, true);
      expect(lastEvent is FirewallBlockEvent, true);
    });

    test('should get from cache if same command send twice', () async {
      var execCount = 0;
      var client = MockClient((request) async {
        execCount++;
        return http.Response.bytes(encode(StringResponse()..value = 'hi'), 200);
      });
      SampleService service = SampleService();

      final cmd1 = CmdEcho(value: 'twin');
      final cmd2 = CmdEcho(value: 'twin');

      var response = await service.executeWithClient(testing.Context(), cmd1, client);
      var response2 = await service.executeWithClient(testing.Context(), cmd2, client);
      expect(response is StringResponse, true);
      expect(response, response2);
      expect(execCount, 1);
    });
  });
}
