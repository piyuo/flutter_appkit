import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/command.dart' as command;
import '../../mock/mock.dart';

const _here = 'command_http_test';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  command.mockCommand();
  var contract;
  var event;

  setUp(() async {
    contract = null;
    event = null;
    eventbus.reset();
    eventbus.listen(_here, (_, e) {
      if (e is eventbus.Contract) {
        contract = e;
      } else {
        event = e;
      }
    });

    eventbus.listen<eventbus.Contract>(_here, (_, e) {
      e.complete(true);
    });
  });

  group('[command-http]', () {
    testWidgets('should return body bytes', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(200));
        var bytes = await command.doPost(ctx, req);
        expect(bytes.length, greaterThan(1));
      });
    });

    testWidgets('should use custom onError', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(500));
        var onErrorCalled = false;
        req.errorHandler = () {
          onErrorCalled = true;
        };
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
        expect(event, null);
        expect(onErrorCalled, true);
      });
    });

    testWidgets('should handle 500, internal server error',
        (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(500));
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
      });
    });

    testWidgets('should handle 501, servie is not properly setup',
        (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(501));
        try {
          await command.doPost(ctx, req);
        } catch (e) {
          expect(e, isNotNull);
        }
      });
    });

    testWidgets('should handle 504, service context deadline exceeded',
        (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(504));
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
      });
    });

    testWidgets('should retry 511 and ok, access token required',
        (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(511));
        var bytes = await command.doPost(ctx, req);
        expect(bytes, isNotNull);
        expect(bytes.length, greaterThan(1));
        expect(contract.runtimeType, command.CAccessTokenRequired);
      });
    });

    testWidgets('should retry 412 and ok, access token expired',
        (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(412));
        var bytes = await command.doPost(ctx, req);
        expect(bytes, isNotNull);
        expect(bytes.length, greaterThan(1));
        expect(contract.runtimeType, command.CAccessTokenExpired);
      });
    });

    testWidgets('should retry 402 and ok, payment token expired',
        (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(402));
        var bytes = await command.doPost(ctx, req);
        expect(bytes, isNotNull);
        expect(bytes.length, greaterThan(1));
        expect(contract.runtimeType, command.CPaymentTokenRequired);
      });
    });

    testWidgets('should handle unknown status', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(101));
        try {
          await command.doPost(ctx, req);
        } catch (e) {
          expect(e, isNotNull);
        }
      });
    });

    testWidgets('should broadcast slow network', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.inWidget((ctx) async {
          var client = MockClient((request) async {
            await Future.delayed(const Duration(milliseconds: 2));
            return http.Response('hi', 200);
          });
          Uint8List bytes = Uint8List.fromList(''.codeUnits);
          await command.post(ctx, client, '', bytes, 500, 1, null);
          expect(event.runtimeType, command.SlowNetworkEvent);
        });
      });
    });

    testWidgets('should no slow network', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var client = MockClient((request) async {
          return http.Response('hi', 200);
        });
        Uint8List bytes = Uint8List.fromList(''.codeUnits);
        await command.post(ctx, client, '', bytes, 500, 3000, null);
        expect(event, null);
      });
    });

    testWidgets('should giveup', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        command.giveup(ctx, command.BadRequestEvent());
        expect(event.runtimeType, command.BadRequestEvent);
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
