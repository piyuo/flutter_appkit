// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/net/net.dart' as net;

void main() {
  dynamic lastEvent;
  eventbus.listen<net.FirewallBlockEvent>((event) async {
    lastEvent = event;
  });

  setUp(() {
    lastEvent = null;
  });

  group('[net.service]', () {
    test('should send command and receive response', () async {
      var client = MockClient((request) async {
        sample.StringResponse sr = sample.StringResponse();
        sr.value = 'hi';
        List<int> bytes = net.encode(sr);
        return http.Response.bytes(bytes, 200);
      });
      final service = sample.SampleService('http://not-exist');
      var response =
          await service.sendByClient(sample.EchoAction()..value = 'hello', client, () => sample.StringResponse());
      expect(response is sample.StringResponse, true);
      if (response is sample.StringResponse) {
        expect(response.value, 'hi');
      }
    });

    test('should use sender to mock response', () async {
      final service = sample.SampleService('http://not-exist')
        ..mockSender = (Object command, {net.Builder? builder}) async {
          return sample.StringResponse()..value = 'fake';
        };

      var response = await service.send(sample.EchoAction()..value = 'hello', builder: () => sample.StringResponse());
      expect(response is sample.StringResponse, true);
      if (response is sample.StringResponse) {
        expect(response.value, 'fake');
      }
    });

    test('should receive null', () async {
      var client = MockClient((request) async {
        return http.Response('', 501);
      });
      final service = sample.SampleService('http://not-exist');
      var response = await service.sendByClient(sample.EchoAction(), client, () => sample.StringResponse());
      expect(response, isNull);
    });

    test('should return null when send wrong action to test server', () async {
      final service = sample.SampleService('http://not-exist')
        ..mockSender = (action, {builder}) async {
          throw Exception('mock');
        };
      sample.EchoAction action = sample.EchoAction();
      expect(() async {
        await service.send(action, builder: () => sample.StringResponse());
      }, throwsException);
    });

    test('should mock execute', () async {
      final service = sample.SampleService('http://not-exist')
        ..mockSender = (action, {builder}) async {
          return sample.StringResponse()..value = 'hi';
        };

      sample.EchoAction action = sample.EchoAction();
      var response = await service.send(action, builder: () => sample.StringResponse());
      expect(response is sample.StringResponse, true);
      if (response is sample.StringResponse) {
        expect(response.value, 'hi');
      }
    });

    test('should use shared object', () async {
      final service = sample.SampleService('http://not-exist')
        ..mockSender = (action, {builder}) async {
          return sample.StringResponse()..value = 'hi';
        };

      sample.EchoAction action = sample.EchoAction();
      var response = await service.send(action, builder: () => sample.StringResponse());
      expect(response is sample.StringResponse, true);
    });

    test('debugPort should return local test url', () async {
      final service = sample.SampleService('http://not-exist');
      service.debugPort = 3001;
      expect(service.url, 'http://localhost:3001');
    });

    test('should block by firewall', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(net.encode(sample.StringResponse()..value = 'hi'), 200);
      });
      sample.SampleService service = sample.SampleService('http://not-exist');

      final action = sample.EchoAction(value: 'firewallBlock');
      net.mockFirewallInFlight(action);

      var response = await service.sendByClient(action, client, () => sample.StringResponse());
      expect(response, isNull);
      expect(lastEvent is net.FirewallBlockEvent, true);
    });

    test('should get from cache if same command send twice', () async {
      var execCount = 0;
      var client = MockClient((request) async {
        execCount++;
        return http.Response.bytes(net.encode(sample.StringResponse()..value = 'hi'), 200);
      });
      sample.SampleService service = sample.SampleService('http://not-exist');

      final cmd1 = sample.EchoAction(value: 'twin');
      final cmd2 = sample.EchoAction(value: 'twin');

      var response = await service.sendByClient(cmd1, client, () => sample.StringResponse());
      var response2 = await service.sendByClient(cmd2, client, () => sample.StringResponse());
      expect(response is sample.StringResponse, true);
      expect(response, response2);
      expect(execCount, 1);
    });
  });
}
