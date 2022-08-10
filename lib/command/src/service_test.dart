// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/command/src/protobuf.dart';
import 'package:libcli/command/src/firewall.dart';

void main() {
  dynamic lastEvent;
  eventbus.listen<FirewallBlockEvent>((event) async {
    lastEvent = event;
  });

  setUp(() {
    lastEvent = null;
  });

  group('[service]', () {
    test('should send command and receive response', () async {
      var client = MockClient((request) async {
        sample.StringResponse sr = sample.StringResponse();
        sr.value = 'hi';
        List<int> bytes = encode(sr);
        return http.Response.bytes(bytes, 200);
      });
      final service = sample.SampleService();
      var response = await service.sendByClient(
          testing.Context(), sample.CmdEcho()..value = 'hello', client, () => sample.StringResponse());
      expect(response is sample.StringResponse, true);
      if (response is sample.StringResponse) {
        expect(response.value, 'hi');
      }
    });

    test('should use sender to mock response', () async {
      final service = sample.SampleService()
        ..sender = (BuildContext ctx, pb.Object command, {pb.Builder? builder}) async {
          return sample.StringResponse()..value = 'fake';
        };

      var response = await service.send(testing.Context(), sample.CmdEcho()..value = 'hello',
          builder: () => sample.StringResponse());
      expect(response is sample.StringResponse, true);
      if (response is sample.StringResponse) {
        expect(response.value, 'fake');
      }
    });

    test('should receive empty', () async {
      var client = MockClient((request) async {
        return http.Response('', 501);
      });
      final service = sample.SampleService();
      var response =
          await service.sendByClient(testing.Context(), sample.CmdEcho(), client, () => sample.StringResponse());
      expect(response is pb.Empty, true);
    });

    test('should return null when send wrong action to test server', () async {
      app.branch = app.branchMaster;
      final service = sample.SampleService()
        ..sender = (ctx, action, {builder}) async {
          throw Exception('mock');
        };
      sample.CmdEcho action = sample.CmdEcho();
      expect(() async {
        await service.send(testing.Context(), action, builder: () => sample.StringResponse());
      }, throwsException);
    });

    test('should mock execute', () async {
      final service = sample.SampleService()
        ..sender = (ctx, action, {builder}) async {
          return sample.StringResponse()..value = 'hi';
        };

      sample.CmdEcho action = sample.CmdEcho();
      var response = await service.send(testing.Context(), action, builder: () => sample.StringResponse());
      expect(response is sample.StringResponse, true);
      if (response is sample.StringResponse) {
        expect(response.value, 'hi');
      }
    });

    test('should use shared object', () async {
      final service = sample.SampleService()
        ..sender = (ctx, action, {builder}) async {
          return sample.StringResponse()..value = 'hi';
        };

      sample.CmdEcho action = sample.CmdEcho();
      var response = await service.send(testing.Context(), action, builder: () => sample.StringResponse());
      expect(response is sample.StringResponse, true);
    });

    test('debugPort should return local test url', () async {
      final service = sample.SampleService();
      service.debugPort = 3001;
      expect(service.url, 'http://localhost:3001');
    });

    test('should block by firewall', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(encode(sample.StringResponse()..value = 'hi'), 200);
      });
      sample.SampleService service = sample.SampleService();

      final action = sample.CmdEcho(value: 'firewallBlock');
      mockFirewallInFlight(action);

      var response = await service.sendByClient(testing.Context(), action, client, () => sample.StringResponse());
      expect(response is FirewallBlock, true);
      expect(lastEvent is FirewallBlockEvent, true);
    });

    test('should get from cache if same command send twice', () async {
      var execCount = 0;
      var client = MockClient((request) async {
        execCount++;
        return http.Response.bytes(encode(sample.StringResponse()..value = 'hi'), 200);
      });
      sample.SampleService service = sample.SampleService();

      final cmd1 = sample.CmdEcho(value: 'twin');
      final cmd2 = sample.CmdEcho(value: 'twin');

      var response = await service.sendByClient(testing.Context(), cmd1, client, () => sample.StringResponse());
      var response2 = await service.sendByClient(testing.Context(), cmd2, client, () => sample.StringResponse());
      expect(response is sample.StringResponse, true);
      expect(response, response2);
      expect(execCount, 1);
    });
  });
}
