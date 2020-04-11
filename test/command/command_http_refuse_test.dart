import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/hook/events.dart';
import 'package:libcli/hook/contracts.dart';
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
      e.complete(false);
    });
  });

  group('[command_http_request_refuse]', () {
    testWidgets('should retry no network but refuse',
        (WidgetTester tester) async {
      var req = newRequest(socketMock());
      req.isInternetConnected = () async {
        return false;
      };

      await tester.inWidget((ctx) async {
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
        expect(contract.runtimeType, CInternetRequired);
        expect(event.runtimeType, ERefuseInternet);
      });
    });

    testWidgets('should retry 511 and failed, access token required',
        (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(511));
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
        expect(contract.runtimeType, CAccessTokenRequired);
        expect(event.runtimeType, ERefuseSignin);
      });
    });

    testWidgets('should retry 412 and failed, access token expired',
        (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(412));
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
        expect(contract.runtimeType, CAccessTokenExpired);
        expect(event.runtimeType, ERefuseSignin);
      });
    });

    testWidgets('should retry 402 and failed, payment token expired',
        (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(402));
        var bytes = await command.doPost(ctx, req);
        expect(bytes, null);
        expect(contract.runtimeType, CPaymentTokenRequired);
        expect(event.runtimeType, ERefuseSignin);
      });
    });

    testWidgets('should retry', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(412));
        await command.retry(ctx, CAccessTokenExpired(), ERefuseSignin(), req);
        expect(event.runtimeType, ERefuseSignin);
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
  return MockClient((request) async {
    throw SocketException('mock');
  });
}

MockClient statucMock(int status) {
  return MockClient((request) async {
    return http.Response('mock', status);
  });
}
