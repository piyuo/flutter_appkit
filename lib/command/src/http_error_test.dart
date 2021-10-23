import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/command/src/test.dart';
import 'package:libcli/command/src/events.dart';
import 'package:libcli/command/src/http.dart';

void main() {
  dynamic contract;

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
        await doPost(testing.Context(), req);
      }, throwsException);
    });

    test('should have contract and return PbEmpty when client timeout', () async {
      var client = MockClient((request) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return http.Response('hi', 200);
      });
      var req = newRequest(client);

      req.timeout = const Duration(milliseconds: 1);
      var obj = await doPost(testing.Context(), req);
      expect(obj is pb.Empty, true);
      expect(contract is RequestTimeoutContract, true);
    });
  });
}
