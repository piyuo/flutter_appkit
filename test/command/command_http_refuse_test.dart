import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/command/command_http.dart' as commandHttp;
import 'package:libcli/event_bus/event_bus.dart' as eventBus;
import 'package:libcli/events/events.dart';

void main() {
  var contract;
  var event;

  setUp(() async {
    contract = null;
    event = null;

    eventBus.listen((e) {
      if (e is eventBus.Contract) {
        contract = e;
      } else {
        event = e;
      }
    });

    eventBus.listen<eventBus.Contract>((e) {
      e.complete(false);
    });
  });

  group('[command_http_request_refuse]', () {
    test('should retry no network but refuse', () async {
      var req = newRequest(socketMock());
      req.isInternetConnected = () async {
        return false;
      };

      var bytes = await commandHttp.doPost(req);
      await eventBus.doneForTest();
      expect(bytes, null);
      expect(contract.runtimeType, CInternetRequired);
      expect(event.runtimeType, ERefuseInternet);
    });

    test('should retry 511 and failed, access token required', () async {
      var req = newRequest(statucMock(511));
      var bytes = await commandHttp.doPost(req);
      await eventBus.doneForTest();
      expect(bytes, null);
      expect(contract.runtimeType, CAccessTokenRequired);
      expect(event.runtimeType, ERefuseSignin);
    });

    test('should retry 412 and failed, access token expired', () async {
      var req = newRequest(statucMock(412));
      var bytes = await commandHttp.doPost(req);
      await eventBus.doneForTest();
      expect(bytes, null);
      expect(contract.runtimeType, CAccessTokenExpired);
      expect(event.runtimeType, ERefuseSignin);
    });

    test('should retry 402 and failed, payment token expired', () async {
      var req = newRequest(statucMock(402));
      var bytes = await commandHttp.doPost(req);
      await eventBus.doneForTest();
      expect(bytes, null);
      expect(contract.runtimeType, CPaymentTokenRequired);
      expect(event.runtimeType, ERefuseSignin);
    });

    test('should retry', () async {
      var req = newRequest(statucMock(412));
      await commandHttp.retry(CAccessTokenExpired(), ERefuseSignin(), req);
      await eventBus.doneForTest();
      expect(event.runtimeType, ERefuseSignin);
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
