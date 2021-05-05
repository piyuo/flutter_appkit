import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/mocking.dart' as mocking;
import 'package:libpb/pb.dart' as pb;
import 'package:libcli/src/command/test.dart';
import 'package:libcli/src/command/events.dart';
import 'package:libcli/src/command/http.dart';

void main() {
  var contractHappening;
  var eventHappening;

  setUp(() async {
    contractHappening = null;
    eventHappening = null;
    eventbus.clearListeners();
    eventbus.listen((_, e) async {
      if (e is eventbus.Contract) {
        contractHappening = e;
      } else {
        eventHappening = e;
      }
    });
  });

  group('[command-http]', () {
    test('should return object', () async {
      var req = newRequest(statusMock(200));
      var obj = await doPost(mocking.Context(), req);
      expect(obj is pb.OK, true);
    });

    test('should handle 500, internal server error', () async {
      var req = newRequest(statusMock(500));
      var response = await doPost(mocking.Context(), req);
      expect(response is pb.Empty, true);
      expect(eventHappening is InternalServerErrorEvent, true);
    });

    test('should handle 501, service is not properly setup', () async {
      var req = newRequest(statusMock(501));
      var response = await doPost(mocking.Context(), req);
      expect(response is pb.Empty, true);
      expect(eventHappening is ServerNotReadyEvent, true);
    });

    test('should handle 504, service context deadline exceeded', () async {
      var req = newRequest(statusMock(504));
      var response = await doPost(mocking.Context(), req);
      expect(response is pb.Empty, true);
      expect(contractHappening is RequestTimeoutContract, true);
    });

    test('should retry 511 and ok, access token required', () async {
      var req = newRequest(statusMock(511));
      var response = await doPost(mocking.Context(), req);
      expect(response is pb.Empty, true);
      expect(contractHappening is CAccessTokenRequired, true);
    });

    test('should retry 412 and ok, access token expired', () async {
      var req = newRequest(statusMock(412));
      var response = await doPost(mocking.Context(), req);
      expect(response is pb.Empty, true);
      expect(contractHappening is CAccessTokenExpired, true);
    });

    test('should retry 402 and ok, payment token expired', () async {
      var req = newRequest(statusMock(402));
      var response = await doPost(mocking.Context(), req);
      expect(response is pb.Empty, true);
      expect(contractHappening is CPaymentTokenRequired, true);
    });

    test('should handle unknown status', () async {
      var req = newRequest(statusMock(101));
      expect(() async => {await doPost(mocking.Context(), req)}, throwsException);
    });

    test('should broadcast slow network', () async {
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response('hi', 200);
      });

      await post(
          mocking.Context(),
          Request(
            service: MockService(),
            client: client,
            action: pb.String(),
            url: 'http://mock',
            timeout: Duration(milliseconds: 500),
            slow: Duration(milliseconds: 1),
          ));
      expect(eventHappening.runtimeType, SlowNetworkEvent);
    });

    test('should no slow network', () async {
      var client = MockClient((request) async {
        return http.Response('hi', 200);
      });
      //Uint8List bytes = Uint8List.fromList(''.codeUnits);
      await post(
          mocking.Context(),
          Request(
            service: MockService(),
            client: client,
            action: pb.String(),
            url: 'http://mock',
            timeout: Duration(milliseconds: 500),
            slow: Duration(milliseconds: 3000),
          ));
      expect(eventHappening, null);
    });

    test('should giveup', () async {
      giveup(mocking.Context(), BadRequestEvent());
      expect(eventHappening.runtimeType, BadRequestEvent);
    });
  });
}

MockClient statusMock(int status) {
  bool badNews = true;
  var resp = http.Response('mock', status);

  return MockClient((request) async {
    if (status == 511 || status == 412 || status == 402) {
      if (badNews) {
        resp = http.Response('', status);
      } else {
        resp = http.Response('ok', 200);
      }
      badNews = !badNews;
    }
    return resp;
  });
}
