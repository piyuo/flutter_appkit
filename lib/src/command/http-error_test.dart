import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/src/eventbus/eventbus.dart' as eventbus;
import 'package:libpb/pb.dart';
import 'package:libcli/src/command/mock-service.dart';
import 'package:libcli/src/mocking/mocking.dart' as mocking;
import 'package:libcli/src/command/events.dart';
import 'package:libcli/src/command/http.dart';

void main() {
  var contract;

  setUp(() async {
    contract = null;
    eventbus.clearListeners();
    eventbus.listen((_, e) async {
      if (e is eventbus.Contract) {
        contract = e;
      }
    });

    eventbus.listen<eventbus.Contract>((_, e) async {
      e.complete(true);
    });
  });

  group('[command-http-error]', () {
    test('should throw exception when something wrong in request()', () async {
      var req = newRequest(MockClient((request) async {
        throw Exception('mock');
      }));
      expect(() async {
        await doPost(mocking.Context(), req);
      }, throwsException);
    });

    test('should have contract and return PbEmpty when client timeout', () async {
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response('hi', 200);
      });
      var req = newRequest(client);

      req.timeout = const Duration(milliseconds: 1);
      var obj = await doPost(mocking.Context(), req);
      expect(obj is PbEmpty, true);
      expect(contract is RequestTimeoutContract, true);
    });
  });
}
