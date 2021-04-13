import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/src/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/src/mocking/mocking.dart' as mocking;
import '../../mock/mock.dart';
import 'package:libcli/src/command/mock-service.dart';
import 'package:libpb/src/pb/pb.dart' as pb;
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
    testWidgets('should return object', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statusMock(200));
        var obj = await doPost(ctx, req);
        expect(obj is pb.OK, true);
      });
    });

    testWidgets('should handle 500, internal server error', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statusMock(500));
        var response = await doPost(ctx, req);
        expect(response is pb.Empty, true);
        expect(eventHappening is InternalServerErrorEvent, true);
      });
    });

    testWidgets('should handle 501, service is not properly setup', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statusMock(501));
        var response = await doPost(ctx, req);
        expect(response is pb.Empty, true);
        expect(eventHappening is ServerNotReadyEvent, true);
      });
    });

    testWidgets('should handle 504, service context deadline exceeded', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statusMock(504));
        var response = await doPost(ctx, req);
        expect(response is pb.Empty, true);
        expect(contractHappening is RequestTimeoutContract, true);
      });
    });

    testWidgets('should retry 511 and ok, access token required', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statusMock(511));
        var response = await doPost(ctx, req);
        expect(response is pb.Empty, true);
        expect(contractHappening is CAccessTokenRequired, true);
      });
    });

    testWidgets('should retry 412 and ok, access token expired', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statusMock(412));
        var response = await doPost(ctx, req);
        expect(response is pb.Empty, true);
        expect(contractHappening is CAccessTokenExpired, true);
      });
    });

    testWidgets('should retry 402 and ok, payment token expired', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statusMock(402));
        var response = await doPost(ctx, req);
        expect(response is pb.Empty, true);
        expect(contractHappening is CPaymentTokenRequired, true);
      });
    });

    testWidgets('should handle unknown status', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statusMock(101));

        expect(() async => {await doPost(ctx, req)}, throwsException);
      });
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

    testWidgets('should giveup', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        giveup(ctx, BadRequestEvent());
        expect(eventHappening.runtimeType, BadRequestEvent);
      });
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
