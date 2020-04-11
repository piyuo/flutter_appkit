import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/hook.dart';
import 'package:libcli/hook.dart';
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/command.dart' as command;
import 'package:libcli/mock/mock.dart';

void main() {
  command.mock();
  var contract;
  var event;

  setUp(() async {
    contract = null;
    event = null;
    eventbus.reset();
    eventbus.listen((_, e) {
      if (e is eventbus.Contract) {
        contract = e;
      } else {
        event = e;
      }
    });

    eventbus.listen<eventbus.Contract>((_, e) {
      e.complete(true);
    });
  });

  group('[command_http_request_exception]', () {
    testWidgets('should throw exception when something wrong in request()',
        (WidgetTester tester) async {
      var req = newRequest(MockClient((request) async {
        throw Exception('mock');
      }));

      await tester.inWidget((ctx) async {
        try {
          await command.doPost(ctx, req);
        } catch (e) {
          expect(e, isNotNull);
        }
      });
    });

    testWidgets('should use custom onError when error happen',
        (WidgetTester tester) async {
      var req = newRequest(MockClient((request) async {
        throw Exception('mock');
      }));
      var onErrorCalled = false;
      req.errorHandler = () {
        onErrorCalled = true;
      };

      await tester.inWidget((ctx) async {
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
        expect(event, null);
        expect(onErrorCalled, true);
      });
    });

    testWidgets('should handle service not available',
        (WidgetTester tester) async {
      var req = newRequest(socketMock());
      req.isInternetConnected = () async {
        return true;
      };
      req.isGoogleCloudFunctionAvailable = () async {
        return true;
      };
      await tester.inWidget((ctx) async {
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
        expect(event.runtimeType, EContactUs);
      });
    });

    testWidgets('should retry service blocked', (WidgetTester tester) async {
      var req = newRequest(socketMock());
      req.isInternetConnected = () async {
        return true;
      };
      req.isGoogleCloudFunctionAvailable = () async {
        return false;
      };
      await tester.inWidget((ctx) async {
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
        expect(event.runtimeType, EServiceBlocked);
      });
    });

    testWidgets('should handle no network', (WidgetTester tester) async {
      var req = newRequest(socketMock());
      req.isInternetConnected = () async {
        return false;
      };

      await tester.inWidget((ctx) async {
        var bytes = await command.doPost(ctx, req);
        expect(bytes, isNotNull);
        expect(bytes.length, greaterThan(1));
        expect(contract.runtimeType, CInternetRequired);
      });
    });

    testWidgets('should handle client timeout', (WidgetTester tester) async {
      await tester.runAsync(() async {
        //runAsync fix Future.delayed stop problem
        var client = MockClient((request) async {
          await Future.delayed(const Duration(milliseconds: 2));
          return http.Response('hi', 200);
        });

        var context = await tester.mockContext();
        var req = newRequest(client);
        req.timeout = 1;
        var bytes = await command.doPost(context, req);
        expect(bytes, null);
        expect(event.runtimeType, EClientTimeout);
      });
    });

    testWidgets('should use onError when client timeout',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        var client = MockClient((request) async {
          await Future.delayed(const Duration(milliseconds: 2));
          return http.Response('hi', 200);
        });
        var req = newRequest(client);
        var onErrorCalled = false;
        req.errorHandler = () {
          onErrorCalled = true;
        };

        await tester.inWidget((ctx) async {
          req.timeout = 1;
          var bytes = await command.doPost(ctx, req);
          expect(bytes, null);
          expect(event, null);
          expect(onErrorCalled, true);
        });
      });
    });
  });
}

command.Request newRequest(MockClient client) {
  var req = command.Request();
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
