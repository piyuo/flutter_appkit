// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/command/src/events.dart';
import 'package:libcli/command/src/http.dart';
import 'package:libcli/command/src/service.dart';
import 'package:libcli/command/src/protobuf.dart';

void main() {
  dynamic eventHappening;

  setUp(() async {
    eventHappening = null;
    eventbus.clearListeners();
    eventbus.listen((e) async {
      eventHappening = e;
    });
  });

  group('[command_http]', () {
    test('should return object', () async {
      var req = _fakeOkRequest(statusOkMock());
      var obj = await doPost(req, () => pb.OK());
      expect(obj is pb.OK, true);
    });

    test('should handle 500, internal server error', () async {
      var req = _fakeOkRequest(statusMockClient(500));
      var response = await doPost(req, () => sample.StringResponse());
      expect(response is pb.Empty, true);
      expect(eventHappening is InternalServerErrorEvent, true);
    });

    test('should handle 501, service is not properly setup', () async {
      var req = _fakeOkRequest(statusMockClient(501));
      var response = await doPost(req, () => sample.StringResponse());
      expect(response is pb.Empty, true);
      expect(eventHappening is ServerNotReadyEvent, true);
    });

    test('should handle 504, service context deadline exceeded', () async {
      var req = _fakeOkRequest(statusMockClient(504));
      var response = await doPost(req, () => sample.StringResponse());
      expect(response is pb.Empty, true);
      expect(eventHappening is RequestTimeoutEvent, true);
    });

    test('should retry 511 and ok, logout required', () async {
      var req = _fakeOkRequest(statusMockClient(511));
      var response = await doPost(req, () => sample.StringResponse());
      expect(response is pb.Empty, true);
      expect(eventHappening is ForceLogOutEvent, isTrue);
    });
    test('should retry 412 and ok, access token expired', () async {
      var req = _fakeOkRequest(statusMockClient(412));
      var response = await doPost(req, () => sample.StringResponse());
      expect(response is pb.OK, true);
      expect(eventHappening is AccessTokenRevokedEvent, isTrue);
    });

    test('should retry 402 and ok, payment token expired', () async {
      var req = _fakeOkRequest(statusMockClient(402));
      var response = await doPost(req, () => sample.StringResponse());
      expect(response is pb.OK, true);
      expect(eventHappening is AccessTokenRevokedEvent, isTrue);
    });

    test('should handle unknown status', () async {
      var req = _fakeOkRequest(statusMockClient(101));
      expect(() async => {await doPost(req, () => sample.StringResponse())}, throwsException);
    });

    test('should broadcast slow network', () async {
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response.bytes(encode(pb.OK()), 200);
      });

      await post(
          Request(
            service: _FakeOkService()..mockSender = (pb.Object command, {pb.Builder? builder}) async => pb.OK(),
            client: client,
            action: pb.OK(),
            url: 'http://mock',
            timeout: const Duration(milliseconds: 500),
            slow: const Duration(milliseconds: 1),
          ),
          () => pb.OK());
      expect(eventHappening.runtimeType, SlowNetworkEvent);
    });

    test('should no slow network', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(encode(pb.OK()), 200);
      });
      //Uint8List bytes = Uint8List.fromList(''.codeUnits);
      await post(
          Request(
            service: _FakeOkService()..mockSender = (pb.Object command, {pb.Builder? builder}) async => pb.OK(),
            client: client,
            action: pb.OK(),
            url: 'http://mock',
            timeout: const Duration(milliseconds: 500),
            slow: const Duration(milliseconds: 3000),
          ),
          () => pb.OK());
      expect(eventHappening, null);
    });

    test('should giveup', () async {
      giveup(BadRequestEvent());
      expect(eventHappening.runtimeType, BadRequestEvent);
    });
  });
}

MockClient statusOkMock() {
  return MockClient((request) async {
    return http.Response.bytes(encode(pb.OK()), 200);
  });
}

MockClient statusMockClient(int status) {
  bool badNews = true;
  var resp = http.Response('mock', status);
  return MockClient((request) async {
    if (status == 511 || status == 412 || status == 402) {
      if (badNews) {
        resp = http.Response('', status);
      } else {
        resp = http.Response.bytes(encode(pb.OK()), 200);
      }
      badNews = !badNews;
    }
    return resp;
  });
}

/// _FakeService only return pb.OK object
class _FakeOkService extends Service {
  _FakeOkService() : super('mock') {
    urlBuilder = () {
      urlBuilderCallCount++;
      return 'http://mock';
    };
    accessTokenBuilder = () async {
      accessTokenBuilderCallCount++;
      return 'mockAccessToken';
    };
    acceptLanguage = () => 'en-US';
  }

  int urlBuilderCallCount = 0;

  int accessTokenBuilderCallCount = 0;
}

_FakeOkService? _fakeService;

/// _fakeRequest return a fake service request
Request _fakeOkRequest(MockClient client) {
  _fakeService = _FakeOkService()..mockSender = (pb.Object command, {pb.Builder? builder}) async => pb.OK();
  return Request(
    service: _fakeService!,
    client: client,
    action: pb.OK(),
    url: 'http://mock',
    timeout: const Duration(milliseconds: 9000),
    slow: const Duration(milliseconds: 9000),
  );
}
