// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/net/net.dart' as net;
import 'package:libcli/common/common.dart' as common;

void main() {
  dynamic eventHappening;

  setUp(() async {
    eventHappening = null;
    eventbus.clearListeners();
    eventbus.listen((e) async {
      eventHappening = e;
    });
  });

  group('[net.http]', () {
    test('should return object', () async {
      var req = _fakeOkRequest(statusOkMock());
      var obj = await net.doPost(req, () => common.OK());
      expect(obj is common.OK, true);
    });

    test('should handle 500, internal server error', () async {
      var req = _fakeOkRequest(statusMockClient(500));
      var response = await net.doPost(req, () => sample.StringResponse());
      expect(response is net.Empty, true);
      expect(eventHappening is net.InternalServerErrorEvent, true);
    });

    test('should handle 501, service is not properly setup', () async {
      var req = _fakeOkRequest(statusMockClient(501));
      var response = await net.doPost(req, () => sample.StringResponse());
      expect(response is net.Empty, true);
      expect(eventHappening is net.ServerNotReadyEvent, true);
    });

    test('should handle 504, service context deadline exceeded', () async {
      var req = _fakeOkRequest(statusMockClient(504));
      var response = await net.doPost(req, () => sample.StringResponse());
      expect(response is net.Empty, true);
      expect(eventHappening is net.RequestTimeoutEvent, true);
    });

    test('should retry 511 and ok, logout required', () async {
      var req = _fakeOkRequest(statusMockClient(511));
      var response = await net.doPost(req, () => sample.StringResponse());
      expect(response is net.Empty, true);
      expect(eventHappening is net.ForceLogOutEvent, isTrue);
    });
    test('should retry 412 and ok, access token expired', () async {
      var req = _fakeOkRequest(statusMockClient(412));
      var response = await net.doPost(req, () => sample.StringResponse());
      expect(response is common.OK, true);
      expect(eventHappening is net.AccessTokenRevokedEvent, isTrue);
    });

    test('should retry 402 and ok, payment token expired', () async {
      var req = _fakeOkRequest(statusMockClient(402));
      var response = await net.doPost(req, () => sample.StringResponse());
      expect(response is common.OK, true);
      expect(eventHappening is net.AccessTokenRevokedEvent, isTrue);
    });

    test('should handle unknown status', () async {
      var req = _fakeOkRequest(statusMockClient(101));
      expect(() async => {await net.doPost(req, () => sample.StringResponse())}, throwsException);
    });

    test('should broadcast slow network', () async {
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response.bytes(net.encode(common.OK()), 200);
      });

      await net.post(
          net.Request(
            service: _FakeOkService()..mockSender = (Object command, {net.Builder? builder}) async => common.OK(),
            client: client,
            action: common.OK(),
            url: 'http://mock',
            timeout: const Duration(milliseconds: 500),
            slow: const Duration(milliseconds: 1),
          ),
          () => common.OK());
      expect(eventHappening.runtimeType, net.SlowNetworkEvent);
    });

    test('should no slow network', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(net.encode(common.OK()), 200);
      });
      //Uint8List bytes = Uint8List.fromList(''.codeUnits);
      await net.post(
          net.Request(
            service: _FakeOkService()..mockSender = (Object command, {net.Builder? builder}) async => common.OK(),
            client: client,
            action: common.OK(),
            url: 'http://mock',
            timeout: const Duration(milliseconds: 500),
            slow: const Duration(milliseconds: 3000),
          ),
          () => common.OK());
      expect(eventHappening, null);
    });

    test('should giveup', () async {
      net.giveup(net.BadRequestEvent());
      expect(eventHappening.runtimeType, net.BadRequestEvent);
    });
  });
}

MockClient statusOkMock() {
  return MockClient((request) async {
    return http.Response.bytes(net.encode(common.OK()), 200);
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
        resp = http.Response.bytes(net.encode(common.OK()), 200);
      }
      badNews = !badNews;
    }
    return resp;
  });
}

/// _FakeService only return common.OK object
class _FakeOkService extends net.Service {
  _FakeOkService() : super('mock', 'http://mock') {
    accessTokenBuilder = () async {
      accessTokenBuilderCallCount++;
      return 'mockAccessToken';
    };
  }

  int accessTokenBuilderCallCount = 0;
}

_FakeOkService? _fakeService;

/// _fakeRequest return a fake service request
net.Request _fakeOkRequest(MockClient client) {
  _fakeService = _FakeOkService()..mockSender = (Object command, {net.Builder? builder}) async => common.OK();
  return net.Request(
    service: _fakeService!,
    client: client,
    action: common.OK(),
    url: 'http://mock',
    timeout: const Duration(milliseconds: 9000),
    slow: const Duration(milliseconds: 9000),
  );
}
