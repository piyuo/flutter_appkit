import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/command.dart' as command;
import '../../mock/mock.dart';
import 'package:libcli/src/command/mock-service_test.dart';

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

  group('[command-http-error]', () {
    testWidgets('should throw exception when something wrong in request()', (WidgetTester tester) async {
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

    testWidgets('should throw exception when error happen', (WidgetTester tester) async {
      var req = newRequest(MockClient((request) async {
        throw Exception('mock');
      }));

      await tester.inWidget((ctx) async {
        expect(() async => await command.doPost(ctx, req), throwsException);

//        var bytes = ;
        //      expect(bytes, null);
        //    expect(event, null);
        //  expect(contract, null);
        //expect(onErrorCalled, true);
      });
    });

    testWidgets('should use onError when client timeout', (WidgetTester tester) async {
      await tester.runAsync(() async {
        var client = MockClient((request) async {
          await Future.delayed(const Duration(milliseconds: 2));
          return http.Response('hi', 200);
        });
        var req = newRequest(client);

        await tester.inWidget((ctx) async {
          req.timeout = 1;
          expect(() async => await command.doPost(ctx, req), throwsException);

//          var bytes = await command.doPost(ctx, req);
          //        expect(bytes, null);
          //      expect(event, null);
          //    expect(onErrorCalled, true);
        });
      });
    });
  });
}

command.Request newRequest(MockClient client) {
  return command.Request(
    service: MockService(),
    client: client,
    bytes: Uint8List(2),
    url: 'http://mock',
    timeout: 9000,
  );
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
