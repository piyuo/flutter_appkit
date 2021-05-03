import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libpb/src/pb/pb.dart' as pb;
import 'package:libcli/env.dart' as env;
import 'package:libcli/mock/protobuf/string-response.pbserver.dart';
import 'package:libcli/mock/protobuf/command-echo.pbserver.dart';
import 'package:libcli/mock/protobuf/sample_service.pb.dart';
import 'package:libcli/mocking.dart' as mocking;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/src/command/test.dart';
import 'package:libcli/src/command/guard.dart';
import 'package:libcli/src/command/events.dart';
import 'package:libcli/src/command/protobuf.dart';

void main() {
  var lastEvent;
  eventbus.listen<GuardDeniedEvent>((BuildContext ctx, event) async {
    lastEvent = event;
  });

  setUp(() {
    lastEvent = null;
    guardRecords = [];
  });

  group('[command]', () {
    test('should send command and receive response', () async {
      var client = MockClient((request) async {
        StringResponse sr = StringResponse();
        sr.value = 'hi';
        List<int> bytes = encode(sr);
        return http.Response.bytes(bytes, 200);
      });
      SampleService service = SampleService();
      var response = await service.executeWithClient(mocking.Context(), CommandEcho()..value = 'hello', client);
      expect(response is StringResponse, true);
      if (response is StringResponse) {
        expect(response.value, 'hi');
      }
    });

    test('should receive empty', () async {
      var client = MockClient((request) async {
        return http.Response('', 501);
      });
      MockService service = MockService();
      var response = await service.executeWithClient(mocking.Context(), CommandEcho(), client);
      expect(response is pb.Empty, true);
    });

    test('should return null when send wrong action to test server', () async {
      env.branch = env.BRANCH_MASTER;
      var service = MockService()
        ..mockExecute = (ctx, action) async {
          throw Exception('mock');
        };
      CommandEcho action = new CommandEcho();
      expect(() async {
        await service.execute(mocking.Context(), action);
      }, throwsException);
    });

    test('should mock execute', () async {
      var service = MockService()
        ..mockExecute = (ctx, action) async {
          return StringResponse()..value = 'hi';
        };

      CommandEcho action = new CommandEcho();
      var response = await service.execute(mocking.Context(), action);
      expect(response is StringResponse, true);
      if (response is StringResponse) {
        expect(response.value, 'hi');
      }
    });

    test('should use shared object', () async {
      var service = MockService()
        ..mockExecute = (ctx, action) async {
          return StringResponse()..value = 'hi';
        };

      CommandEcho action = new CommandEcho();
      var response = await service.execute(mocking.Context(), action);
      expect(response is StringResponse, true);
    });

    test('debugPort should return local test url', () async {
      MockService service = MockService();
      service.debugPort = 3001;
      expect(service.url, 'http://localhost:3001');
    });

    test('should failed on default guard rule 1', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(encode(StringResponse()..value = 'hi'), 200);
      });
      SampleService service = SampleService();
      //send first time
      var response = await service.executeWithClient(mocking.Context(), CommandEcho(), client);
      expect(response is StringResponse, true);

      //send second time
      response = await service.executeWithClient(mocking.Context(), CommandEcho(), client);
      expect(response is pb.Error, true);
      if (response is pb.Error) {
        expect(response.code, 'GUARD_1');
      }
      expect(lastEvent is GuardDeniedEvent, true);
    });

    test('should failed on default guard rule 2', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(encode(StringResponse()..value = 'hi'), 200);
      });
      SampleService service = SampleService();
      var rule = GuardRule(
        duration1: Duration.zero,
        count1: 0,
        duration2: Duration(seconds: 5),
        count2: 1,
      );

      //send first time
      var response = await service.executeWithClient(mocking.Context(), CommandEcho(), client, rule: rule);
      expect(response is StringResponse, true);
      if (response is pb.Error) {
        expect(response.code, 'GUARD_1');
      }

      //send second time
      response = await service.executeWithClient(mocking.Context(), CommandEcho(), client, rule: rule);
      expect(response is pb.Error, true);
      expect(lastEvent is GuardDeniedEvent, true);
    });

    test('should not broadcast guard denied', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(encode(StringResponse()..value = 'hi'), 200);
      });
      SampleService service = SampleService();
      //send first time
      var response = await service.executeWithClient(mocking.Context(), CommandEcho(), client);
      expect(response is StringResponse, true);

      //send second time
      response = await service.executeWithClient(mocking.Context(), CommandEcho(), client, broadcastDenied: false);
      expect(response is pb.Error, true);
      var error = response as pb.Error;
      expect(error.code, 'GUARD_1');
      expect(lastEvent, isNull);
    });
  });
}
