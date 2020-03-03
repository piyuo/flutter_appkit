import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/command/command_http.dart' as commandHttp;
import 'package:libcli/events/events.dart';
import 'package:libcli/event_bus/event_bus.dart' as eventBus;

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
      e.complete(true);
    });
  });

  group('[command_http_request_exception]', () {
    test('should throw exception when something wrong in request()', () async {
      var req = newRequest(MockClient((request) async {
        throw Exception('mock');
      }));
      try {
        await commandHttp.doPost(req);
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('should use custom onError when error happen', () async {
      var req = newRequest(MockClient((request) async {
        throw Exception('mock');
      }));
      var onErrorCalled = false;
      req.onError = () {
        onErrorCalled = true;
      };
      var bytes = await commandHttp.doPost(req);
      await eventBus.doneForTest();
      expect(bytes, null);
      expect(event, null);
      expect(onErrorCalled, true);
    });

    test('should handle service not available', () async {
      var req = newRequest(socketMock());
      req.isInternetConnected = () async {
        return true;
      };
      req.isGoogleCloudFunctionAvailable = () async {
        return true;
      };
      var bytes = await commandHttp.doPost(req);
      await eventBus.doneForTest();
      expect(bytes, null);
      expect(event.runtimeType, EContactUs);
    });

    test('should retry service blocked', () async {
      var req = newRequest(socketMock());
      req.isInternetConnected = () async {
        return true;
      };
      req.isGoogleCloudFunctionAvailable = () async {
        return false;
      };
      var bytes = await commandHttp.doPost(req);
      await eventBus.doneForTest();
      expect(bytes, null);
      expect(event.runtimeType, EServiceBlocked);
    });

    test('should handle no network', () async {
      var req = newRequest(socketMock());
      req.isInternetConnected = () async {
        return false;
      };
      var bytes = await commandHttp.doPost(req);
      await eventBus.doneForTest();
      expect(bytes, isNotNull);
      expect(bytes.length, greaterThan(1));
      expect(contract.runtimeType, CInternetRequired);
    });

    test('should handle client timeout', () async {
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response('hi', 200);
      });
      var req = newRequest(client);
      req.timeout = 1;
      var bytes = await commandHttp.doPost(req);
      await eventBus.doneForTest();
      expect(bytes, null);
      expect(event.runtimeType, EClientTimeout);
    });

    test('should use onError when client timeout', () async {
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response('hi', 200);
      });
      var req = newRequest(client);
      var onErrorCalled = false;
      req.onError = () {
        onErrorCalled = true;
      };
      req.timeout = 1;
      var bytes = await commandHttp.doPost(req);
      await eventBus.doneForTest();
      expect(bytes, null);
      expect(event, null);
      expect(onErrorCalled, true);
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
  bool badNews = true;
  return MockClient((request) async {
    if (badNews) {
      badNews = !badNews;
      throw SocketException('mock');
    } else {
      badNews = !badNews;
      return http.Response('ok', 200);
    }
  });
}
