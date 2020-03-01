import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/command/command_http.dart' as commandHttp;
import 'package:libcli/contract/contract.dart' as c;
import '../contract/mock_listener.dart';

void main() {
  MockListener okListener = MockListener(false);
  c.removeAllListener();
  c.addListener(okListener);

  group('command_http_request_refuse', () {
    test('should retry no network but refuse', () async {
      okListener.clear();
      var req = newRequest(socketMock());
      req.isInternetConnected = () async {
        return false;
      };
      var bytes = await commandHttp.doPost(req);
      expect(bytes, null);
      expect(okListener.latestContract.runtimeType, c.CInternetRequired);
      expect(okListener.latestEvent.runtimeType, c.ERefuseInternet);
    });

    test('should retry 511 and failed, access token required', () async {
      okListener.clear();
      var req = newRequest(statucMock(511));
      var bytes = await commandHttp.doPost(req);
      expect(bytes, null);
      expect(okListener.latestContract.runtimeType, c.CAccessTokenRequired);
      expect(okListener.latestEvent.runtimeType, c.ERefuseSignin);
    });

    test('should retry 412 and failed, access token expired', () async {
      okListener.clear();
      var req = newRequest(statucMock(412));
      var bytes = await commandHttp.doPost(req);
      expect(bytes, null);
      expect(okListener.latestContract.runtimeType, c.CAccessTokenExpired);
      expect(okListener.latestEvent.runtimeType, c.ERefuseSignin);
    });

    test('should retry 402 and failed, payment token expired', () async {
      okListener.clear();
      var req = newRequest(statucMock(402));
      var bytes = await commandHttp.doPost(req);
      expect(bytes, null);
      expect(okListener.latestContract.runtimeType, c.CPaymentTokenRequired);
      expect(okListener.latestEvent.runtimeType, c.ERefuseSignin);
    });

    test('should retry', () async {
      okListener.clear();
      var req = newRequest(statucMock(412));
      await commandHttp.retry(c.CAccessTokenExpired(), c.ERefuseSignin(), req);
      expect(okListener.latestEvent.runtimeType, c.ERefuseSignin);
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

MockClient socketMock() {
  return MockClient((request) async {
    throw SocketException('mock');
  });
}

MockClient statucMock(int status) {
  return MockClient((request) async {
    return http.Response('mock', status);
  });
}
