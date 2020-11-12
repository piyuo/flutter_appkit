import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/command.dart' as command;
import 'package:libcli/log.dart';
import '../../mock/mock.dart';
import '../../mock/protobuf/sys_service.pb.dart';
import '../../mock/protobuf/string_response.pbserver.dart';
import '../../mock/protobuf/echo_request.pbserver.dart';
import 'package:libcli/app.dart' as config;
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  command.mockCommand();
  debugPrint = overrideDebugPrint;

  setUp(() {});

  group('[command]', () {
    testWidgets('should send command and receive response', (WidgetTester tester) async {
      var client = MockClient((request) async {
        StringResponse sr = StringResponse();
        sr.text = 'hi';
        List<int> bytes = command.encode(sr);
        return http.Response.bytes(bytes, 200);
      });

      await tester.inWidget((ctx) async {
        SysService service = SysService();
        var response = await service.executeWithClient(ctx, EchoAction()..text = 'hello', client);
        if (response is StringResponse) {
          expect(response, isNotNull);
          expect(response.text, 'hi');
        } else {
          expect(1, 0); // should not be here
        }
      });
    });

    testWidgets('should receive null', (WidgetTester tester) async {
      var client = MockClient((request) async {
        return http.Response('', 501);
      });

      await tester.inWidget((ctx) async {
        SysService service = SysService();
        var response = await service.executeWithClient(ctx, EchoAction(), client);
        expect(response, isNull);
      });
    });

    test('should return null when send wrong action to test server', () async {
      config.branch = config.BRANCH_MASTER;
      SysService service = SysService();
      EchoAction action = new EchoAction();
      var response = await service.execute(MockBuildContext(), action);
      expect(response, null);
    });

    test('should mock execute', () async {
      var service = command.MockService((ctx, action) async {
        return StringResponse()..text = 'hi';
      });

      EchoAction action = new EchoAction();
      var response = await service.execute(MockBuildContext(), action);
      if (response is StringResponse) {
        expect(response.text, 'hi');
      } else {
        expect(1, 0);
      }
    });

    test('should execute set state', () async {
      var service = command.MockService((ctx, action) async {
        return StringResponse()..text = 'hi';
      });

      EchoAction action = new EchoAction();
      Map state = Map();
      await service.execute(MockBuildContext(), action, state: state);
      expect(state['err'], '');
    });

    test('should use shared object', () async {
      command.MockService service = command.MockService((_, action) async {
        return command.ok();
      });

      EchoAction action = new EchoAction();
      var response = await service.execute(MockBuildContext(), action);
      if (response is command.Err) {
        expect(response.code, isEmpty);
      } else {
        expect(1, 0);
      }
    });

    test('debugPort should return local test url', () async {
      command.MockService service = command.MockService((_, action) async {
        return command.ok();
      });
      service.debugPort = 3001;
      expect(service.url, 'http://localhost:3001');
    });

    test('should set err state', () async {
      Map map = {};

      command.setErrState(map, command.error(''));
      expect(map['err'], isEmpty);

      command.setErrState(map, command.error('test'));
      expect(map['err'], 'test');

      command.setErrState(map, null);
      expect(map['err'], isNull);
    });
  });
}
