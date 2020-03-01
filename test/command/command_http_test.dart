import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/command/command_http.dart' as commandHttp;
import 'package:libcli/contract/contract.dart' as c;
import '../contract/mock_listener.dart';

void main() {
  MockListener okListener = MockListener(true);
  c.removeAllListener();
  c.addListener(okListener);

  group('command_http_request', () {
    test('should return body bytes', () async {
      okListener.clear();
      var req = newRequest(statucMock(200));
      var bytes = await commandHttp.doPost(req);
      expect(bytes.length, greaterThan(1));
    });

    test('should use custom onError', () async {
      okListener.clear();
      var req = newRequest(statucMock(500));
      var onErrorCalled = false;
      req.onError = () {
        onErrorCalled = true;
      };
      var bytes = await commandHttp.doPost(req);
      expect(bytes, null);
      expect(okListener.latestEvent, null);
      expect(onErrorCalled, true);
    });

    test('should handle 500, internal server error', () async {
      okListener.clear();
      var req = newRequest(statucMock(500));
      var bytes = await commandHttp.doPost(req);
      expect(bytes, null);
      expect(okListener.latestEvent.runtimeType, c.EError);
      c.EError e = okListener.latestEvent as c.EError;
      expect(e.errId, 'mock');
    });

    test('should handle 501, servie is not properly setup', () async {
      okListener.clear();
      var req = newRequest(statucMock(501));
      try {
        await commandHttp.doPost(req);
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('should handle 504, service context deadline exceeded', () async {
      okListener.clear();
      var req = newRequest(statucMock(504));
      var bytes = await commandHttp.doPost(req);
      expect(bytes, null);
      expect(okListener.latestEvent.runtimeType, c.EServiceTimeout);
      c.EServiceTimeout e = okListener.latestEvent as c.EServiceTimeout;
      expect(e.errId, 'mock');
    });

    test('should retry 511 and ok, access token required', () async {
      okListener.clear();
      var req = newRequest(statucMock(511));
      var bytes = await commandHttp.doPost(req);
      expect(bytes, isNotNull);
      expect(bytes.length, greaterThan(1));
      expect(okListener.latestContract.runtimeType, c.CAccessTokenRequired);
    });

    test('should retry 412 and ok, access token expired', () async {
      okListener.clear();
      var req = newRequest(statucMock(412));
      var bytes = await commandHttp.doPost(req);
      expect(bytes, isNotNull);
      expect(bytes.length, greaterThan(1));
      expect(okListener.latestContract.runtimeType, c.CAccessTokenExpired);
    });

    test('should retry 402 and ok, payment token expired', () async {
      okListener.clear();
      var req = newRequest(statucMock(402));
      var bytes = await commandHttp.doPost(req);
      expect(bytes, isNotNull);
      expect(bytes.length, greaterThan(1));
      expect(okListener.latestContract.runtimeType, c.CPaymentTokenRequired);
    });

    test('should handle unknown status', () async {
      okListener.clear();
      var req = newRequest(statucMock(101));
      try {
        await commandHttp.doPost(req);
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('should broadcast slow network', () async {
      okListener.clear();
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response('hi', 200);
      });
      Uint8List bytes = Uint8List.fromList(''.codeUnits);
      await commandHttp.post(client, '', bytes, 500, 1, null);
      expect(okListener.latestEvent.runtimeType, c.ENetworkSlow);
    });

    test('should no slow network', () async {
      okListener.clear();
      var client = MockClient((request) async {
        return http.Response('hi', 200);
      });
      Uint8List bytes = Uint8List.fromList(''.codeUnits);
      await commandHttp.post(client, '', bytes, 500, 3000, null);
      expect(okListener.latestEvent, null);
    });

    test('should giveup', () async {
      okListener.clear();
      commandHttp.giveup(c.ERefuseInternet());
      expect(okListener.latestEvent.runtimeType, c.ERefuseInternet);
    });
  });
}

commandHttp.Request newRequest(MockClient client) {
  var req = commandHttp.Request();
  req.client = client;
  req.bytes = Uint8List(2);
  req.url = 'http://mock';
  req.timeout = 9000;
  return req;
}

MockClient statucMock(int status) {
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
