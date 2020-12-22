import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/command.dart' as command;
import 'package:libcli/app.dart' as config;
import 'package:libcli/src/command/mock-service.dart';
import 'package:libcli/src/command/guard.dart';
import 'package:libcli/src/command/events.dart';
import 'package:libcli/mock/protobuf/string_response.pbserver.dart';
import 'package:libcli/mock/protobuf/echo_request.pbserver.dart';
import 'package:libcli/mock/protobuf/sample_service.pb.dart';
import 'package:libpb/pb.dart';
import 'package:libcli/test.dart';
import 'package:libcli/eventbus.dart';

void main() {
  var lastEvent;
  listen<GuardDeniedEvent>((BuildContext ctx, event) async {
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
        sr.text = 'hi';
        List<int> bytes = command.encode(sr);
        return http.Response.bytes(bytes, 200);
      });
      SampleService service = SampleService();
      var response = await service.executeWithClient(MockBuildContext(), EchoAction()..text = 'hello', client);
      expect(response is StringResponse, true);
      if (response is StringResponse) {
        expect(response.text, 'hi');
      }
    });

    test('should receive empty', () async {
      var client = MockClient((request) async {
        return http.Response('', 501);
      });
      MockService service = MockService();
      var response = await service.executeWithClient(MockBuildContext(), EchoAction(), client);
      expect(response is PbEmpty, true);
    });

    test('should return null when send wrong action to test server', () async {
      config.branch = config.BRANCH_MASTER;
      var service = MockService()
        ..mockExecute = (ctx, action) async {
          throw Exception('mock');
        };
      EchoAction action = new EchoAction();
      expect(() async {
        await service.execute(MockBuildContext(), action);
      }, throwsException);
    });

    test('should mock execute', () async {
      var service = MockService()
        ..mockExecute = (ctx, action) async {
          return StringResponse()..text = 'hi';
        };

      EchoAction action = new EchoAction();
      var response = await service.execute(MockBuildContext(), action);
      expect(response is StringResponse, true);
      if (response is StringResponse) {
        expect(response.text, 'hi');
      }
    });

    test('should use shared object', () async {
      var service = MockService()
        ..mockExecute = (ctx, action) async {
          return StringResponse()..text = 'hi';
        };

      EchoAction action = new EchoAction();
      var response = await service.execute(MockBuildContext(), action);
      expect(response is StringResponse, true);
    });

    test('debugPort should return local test url', () async {
      MockService service = MockService();
      service.debugPort = 3001;
      expect(service.url, 'http://localhost:3001');
    });

    test('should failed on default guard rule 1', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(command.encode(StringResponse()..text = 'hi'), 200);
      });
      SampleService service = SampleService();
      //send first time
      var response = await service.executeWithClient(MockBuildContext(), EchoAction(), client);
      expect(response is StringResponse, true);

      //send second time
      response = await service.executeWithClient(MockBuildContext(), EchoAction(), client);
      expect(response is PbEmpty, true);
      expect(lastEvent is command.GuardDeniedEvent, true);
    });

    test('should failed on default guard rule 2', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(command.encode(StringResponse()..text = 'hi'), 200);
      });
      SampleService service = SampleService();
      var rule = GuardRule(
        duration1: Duration.zero,
        count1: 0,
        duration2: Duration(seconds: 5),
        count2: 1,
      );

      //send first time
      var response = await service.executeWithClient(MockBuildContext(), EchoAction(), client, rule: rule);
      expect(response is StringResponse, true);

      //send second time
      response = await service.executeWithClient(MockBuildContext(), EchoAction(), client, rule: rule);
      expect(response is PbEmpty, true);
      expect(lastEvent is command.GuardDeniedEvent, true);
    });

    test('should not broadcast guard denied', () async {
      var client = MockClient((request) async {
        return http.Response.bytes(command.encode(StringResponse()..text = 'hi'), 200);
      });
      SampleService service = SampleService();
      //send first time
      var response = await service.executeWithClient(MockBuildContext(), EchoAction(), client);
      expect(response is StringResponse, true);

      //send second time
      response = await service.executeWithClient(MockBuildContext(), EchoAction(), client, broadcastDenied: false);
      expect(response is PbError, true);
      var error = response as PbError;
      expect(error.code, 'GURAD_1');
      expect(lastEvent, isNull);
    });
  });
}
