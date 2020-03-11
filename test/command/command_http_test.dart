import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/command/command_http.dart' as commandHttp;
import 'package:libcli/event_bus/event_bus.dart' as eventBus;
import 'package:libcli/hook/events.dart';
import 'package:libcli/hook/contracts.dart';
import 'package:libcli/command/command.dart' as command;

void main() {
  command.mockInit();
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
      e.complete(true);
    });
  });

  group('[command_http_request]', () {
    test('should return body bytes', () async {
      var req = newRequest(statucMock(200));
      var bytes = await commandHttp.doPost(req);
      expect(bytes.length, greaterThan(1));
    });

    test('should use custom onError', () async {
      var req = newRequest(statucMock(500));
      var onErrorCalled = false;
      req.onError = () {
        onErrorCalled = true;
      };
      var bytes = await commandHttp.doPost(req);
      await eventBus.mockDone();
      expect(bytes, null);
      expect(event, null);
      expect(onErrorCalled, true);
    });

    test('should handle 500, internal server error', () async {
      var req = newRequest(statucMock(500));
      var bytes = await commandHttp.doPost(req);
      await eventBus.mockDone();
      expect(bytes, null);
      expect(event.runtimeType, EError);
      EError e = event as EError;
      expect(e.errId, 'mock');
    });

    test('should handle 501, servie is not properly setup', () async {
      var req = newRequest(statucMock(501));
      try {
        await commandHttp.doPost(req);
        await eventBus.mockDone();
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('should handle 504, service context deadline exceeded', () async {
      var req = newRequest(statucMock(504));
      var bytes = await commandHttp.doPost(req);
      await eventBus.mockDone();
      expect(bytes, null);
      expect(event.runtimeType, EServiceTimeout);
      EServiceTimeout e = event as EServiceTimeout;
      expect(e.errId, 'mock');
    });

    test('should retry 511 and ok, access token required', () async {
      var req = newRequest(statucMock(511));
      var bytes = await commandHttp.doPost(req);
      await eventBus.mockDone();
      expect(bytes, isNotNull);
      expect(bytes.length, greaterThan(1));
      expect(contract.runtimeType, CAccessTokenRequired);
    });

    test('should retry 412 and ok, access token expired', () async {
      var req = newRequest(statucMock(412));
      var bytes = await commandHttp.doPost(req);
      await eventBus.mockDone();
      expect(bytes, isNotNull);
      expect(bytes.length, greaterThan(1));
      expect(contract.runtimeType, CAccessTokenExpired);
    });

    test('should retry 402 and ok, payment token expired', () async {
      var req = newRequest(statucMock(402));
      var bytes = await commandHttp.doPost(req);
      await eventBus.mockDone();
      expect(bytes, isNotNull);
      expect(bytes.length, greaterThan(1));
      expect(contract.runtimeType, CPaymentTokenRequired);
    });

    test('should handle unknown status', () async {
      var req = newRequest(statucMock(101));
      try {
        await commandHttp.doPost(req);
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('should broadcast slow network', () async {
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response('hi', 200);
      });
      Uint8List bytes = Uint8List.fromList(''.codeUnits);
      await commandHttp.post(client, '', bytes, 500, 1, null);
      await eventBus.mockDone();
      expect(event.runtimeType, ENetworkSlow);
    });

    test('should no slow network', () async {
      var client = MockClient((request) async {
        return http.Response('hi', 200);
      });
      Uint8List bytes = Uint8List.fromList(''.codeUnits);
      await commandHttp.post(client, '', bytes, 500, 3000, null);
      await eventBus.mockDone();
      expect(event, null);
    });

    test('should giveup', () async {
      commandHttp.giveup(ERefuseInternet());
      await eventBus.mockDone();
      expect(event.runtimeType, ERefuseInternet);
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
