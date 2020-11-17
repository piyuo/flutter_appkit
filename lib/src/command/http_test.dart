import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/command.dart' as command;
import '../../mock/mock.dart';
import 'package:libcli/src/command/mock-service_test.dart';
import 'package:libcli/command.dart';
import 'package:libpb/pb.dart' as pb;

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  command.mockCommand();
  var contract;
  var event;

  setUp(() async {
    contract = null;
    event = null;
    eventbus.clearListeners();
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

  group('[command-http]', () {
    testWidgets('should return object', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(200));
        var obj = await command.doPost(ctx, req);
        expect(pb.ProtoObject.isEmpty(obj), false);
      });
    });

    testWidgets('should use custom onError', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(500));
        expect(() async => await command.doPost(ctx, req), throwsException);
      });
    });

    testWidgets('should handle 500, internal server error', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(500));
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
      });
    });

    testWidgets('should handle 501, servie is not properly setup', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(501));
        try {
          await command.doPost(ctx, req);
        } catch (e) {
          expect(e, isNotNull);
        }
      });
    });

    testWidgets('should handle 504, service context deadline exceeded', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(504));
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
      });
    });

    testWidgets('should retry 511 and ok, access token required', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(511));
        var obj = await command.doPost(ctx, req);
        expect(command.isOK(obj), true);
        expect(contract.runtimeType, command.CAccessTokenRequired);
      });
    });

    testWidgets('should retry 412 and ok, access token expired', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(412));
        var obj = await command.doPost(ctx, req);
        expect(command.isOK(obj), true);
        expect(contract.runtimeType, command.CAccessTokenExpired);
      });
    });

    testWidgets('should retry 402 and ok, payment token expired', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(402));
        var obj = await command.doPost(ctx, req);
        expect(command.isOK(obj), true);
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
//          Uint8List bytes = Uint8List.fromList(''.codeUnits);
          await command.post(ctx, MockService(), client, '', ok(), 500, 1);
          expect(event.runtimeType, command.SlowNetworkEvent);
        });
      });
    });

    testWidgets('should no slow network', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var client = MockClient((request) async {
          return http.Response('hi', 200);
        });
        //Uint8List bytes = Uint8List.fromList(''.codeUnits);
        await command.post(ctx, MockService(), client, '', ok(), 500, 3000);
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
  MockService service = MockService();
  return command.Request(
    service: service,
    client: client,
    bytes: Uint8List(2),
    url: 'http://mock',
    timeout: 9000,
  );
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
