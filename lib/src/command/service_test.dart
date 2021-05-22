import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libpb/pb.dart' as pb;
import 'package:libcli/env.dart' as env;
import 'package:libcli/mocking.dart' as mocking;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/mock/protobuf/string-response.pbserver.dart';
import 'package:libcli/mock/protobuf/command-echo.pbserver.dart';
import 'package:libcli/mock/protobuf/sample_service.pb.dart';
import 'package:libcli/src/command/test.dart';
import 'package:libcli/src/command/protobuf.dart';
import 'package:libcli/src/command/firewall.dart';

void main() {
  var lastEvent;
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
      var response = await service.executeWithClient(mocking.Context(), CommandEcho()..value = 'hello', client);
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
      var response = await service.executeWithClient(mocking.Context(), CommandEcho(), client);
      expect(response is pb.Empty, true);
    });

    test('should return null when send wrong action to test server', () async {
      env.branch = env.BRANCH_MASTER;
      var service = MockService()
        ..mockExecute = (ctx, action) async {
          throw Exception('mock');
        };
      CommandEcho action = new CommandEcho();
      expect(() async {
        await service.execute(mocking.Context(), action);
      }, throwsException);
    });

    test('should mock execute', () async {
      var service = MockService()
        ..mockExecute = (ctx, action) async {
          return StringResponse()..value = 'hi';
        };

      CommandEcho action = new CommandEcho();
      var response = await service.execute(mocking.Context(), action);
      expect(response is StringResponse, true);
      if (response is StringResponse) {
        expect(response.value, 'hi');
      }
    });

    test('should use shared object', () async {
      var service = MockService()
        ..mockExecute = (ctx, action) async {
          return StringResponse()..value = 'hi';
        };

      CommandEcho action = new CommandEcho();
      var response = await service.execute(mocking.Context(), action);
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

      final cmd = CommandEcho(value: 'firewallBlock');
      mockFirewallInFlight(cmd.jsonString);

      var response = await service.executeWithClient(mocking.Context(), cmd, client);
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

      final cmd1 = CommandEcho(value: 'twin');
      final cmd2 = CommandEcho(value: 'twin');

      var response = await service.executeWithClient(mocking.Context(), cmd1, client);
      var response2 = await service.executeWithClient(mocking.Context(), cmd2, client);
      expect(response is StringResponse, true);
      expect(response, response2);
      expect(execCount, 1);
    });
  });
}
