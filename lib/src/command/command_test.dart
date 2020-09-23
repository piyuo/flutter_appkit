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
import 'package:libcli/configuration.dart';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  command.mockCommand();
  debugPrint = overrideDebugPrint;

  setUp(() {});

  group('[command]', () {
    testWidgets('should send command and receive response',
        (WidgetTester tester) async {
      var client = MockClient((request) async {
        StringResponse sr = StringResponse();
        sr.text = 'hi';
        List<int> bytes = command.encode(sr);
        return http.Response.bytes(bytes, 200);
      });

      await tester.inWidget((ctx) async {
        SysService service = SysService();
        var response = await service.executeWithClient(
            ctx, EchoAction()..text = 'hello', client);
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
        var response =
            await service.executeWithClient(ctx, EchoAction(), client);
        expect(response, isNull);
      });
    });

    test('should return null when send wrong action to test server', () async {
      setBranch(BRANCH_MASTER);
      SysService service = SysService();
      EchoAction action = new EchoAction();
      var response = await service.execute(null, action);
      expect(response, null);
    });

    test('should mock execute', () async {
      var service = command.MockService((ctx, action) async {
        return StringResponse()..text = 'hi';
      });

      EchoAction action = new EchoAction();
      var response = await service.execute(null, action);
      if (response is StringResponse) {
        expect(response.text, 'hi');
      } else {
        expect(1, 0);
      }
    });

    test('should use shared object', () async {
      command.MockService service = command.MockService((_, action) async {
        return command.ok();
      });

      EchoAction action = new EchoAction();
      var response = await service.execute(null, action);
      if (response is command.Err) {
        expect(response.code, command.OK);
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
  });
}
