import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/command.dart';
import 'package:libpb/pb.dart';
import '../../mock/mock.dart';
import 'package:libcli/src/command/mock-service_test.dart';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  mockCommand();
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
      e.complete(false);
    });
  });

  group('[command-http-refuse]', () {
    testWidgets('should retry 511 and failed, access token required', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(511));
        var bytes = await doPost(ctx, req);
        expect(bytes, null);
        expect(contract.runtimeType, CAccessTokenRequired);
        expect(event.runtimeType, ERefuseSignin);
      });
    });

    testWidgets('should retry 412 and failed, access token expired', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(412));
        var bytes = await doPost(ctx, req);
        expect(bytes, null);
        expect(contract.runtimeType, CAccessTokenExpired);
        expect(event.runtimeType, ERefuseSignin);
      });
    });

    testWidgets('should retry 402 and failed, payment token expired', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(402));
        var bytes = await doPost(ctx, req);
        expect(bytes, null);
        expect(contract.runtimeType, CPaymentTokenRequired);
        expect(event.runtimeType, ERefuseSignin);
      });
    });

    testWidgets('should retry', (WidgetTester tester) async {
      await tester.inWidget((ctx) async {
        var req = newRequest(statucMock(412));
        var obj = await retry(ctx, contract: CAccessTokenExpired(), request: req);
        expect(ProtoObject.isEmpty(obj), ERefuseSignin);
      });
    });
  });
}

Request newRequest(MockClient client) {
  MockService service = MockService();

  return Request(
    service: service,
    client: client,
    bytes: Uint8List(2),
    url: 'http://mock',
    timeout: 9000,
  );
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
