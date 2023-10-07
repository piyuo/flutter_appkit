// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/net/net.dart' as net;

void main() {
  dynamic lastEvent;

  setUp(() async {
    lastEvent = null;
    eventbus.clearListeners();
    eventbus.listen((e) async {
      lastEvent = e;
    });
  });

  group('[net.http_error]', () {
    test('should throw exception when something wrong in request()', () async {
      var req = _fakeSampleRequest(MockClient((request) async {
        throw Exception('mock');
      }));
      expect(() async {
        await net.doPost(req, () => sample.StringResponse());
      }, throwsException);
    });

    test('should have contract and return PbEmpty when client timeout', () async {
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response('hi', 200);
      });
      var req = _fakeSampleRequest(client);

      req.timeout = const Duration(milliseconds: 1);
      var obj = await net.doPost(req, () => sample.StringResponse());
      expect(obj, isNull);
      expect(lastEvent is net.RequestTimeoutEvent, true);
    });
  });
}

/// _fakeRequest return a fake service request
net.Request _fakeSampleRequest(MockClient client) {
  return net.Request(
    service: sample.SampleService('http://mock'),
    client: client,
    action: sample.EchoAction(),
    url: 'http://mock',
    timeout: const Duration(milliseconds: 9000),
    slow: const Duration(milliseconds: 9000),
  );
}
