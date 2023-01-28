// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/command/src/events.dart';
import 'package:libcli/command/src/http.dart';

void main() {
  dynamic lastEvent;

  setUp(() async {
    lastEvent = null;
    eventbus.clearListeners();
    eventbus.listen((e) async {
      lastEvent = e;
    });
  });

  group('[command-http-error]', () {
    test('should throw exception when something wrong in request()', () async {
      var req = _fakeSampleRequest(MockClient((request) async {
        throw Exception('mock');
      }));
      expect(() async {
        await doPost(req, () => sample.StringResponse());
      }, throwsException);
    });

    test('should have contract and return PbEmpty when client timeout', () async {
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response('hi', 200);
      });
      var req = _fakeSampleRequest(client);

      req.timeout = const Duration(milliseconds: 1);
      var obj = await doPost(req, () => sample.StringResponse());
      expect(obj is pb.Empty, true);
      expect(lastEvent is RequestTimeoutEvent, true);
    });
  });
}

/// _fakeRequest return a fake service request
Request _fakeSampleRequest(MockClient client) {
  return Request(
    service: sample.SampleService(),
    client: client,
    action: pb.OK(),
    url: 'http://mock',
    timeout: const Duration(milliseconds: 9000),
    slow: const Duration(milliseconds: 9000),
  );
}
