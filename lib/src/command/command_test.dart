import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/command.dart' as command;
import 'package:libcli/app.dart' as config;
import 'package:libpb/pb.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/command/mock-service_test.dart' as mockServiceTest;
import '../../mock/mock.dart';
import '../../mock/protobuf/mock_service.pb.dart';
import '../../mock/protobuf/string_response.pbserver.dart';
import '../../mock/protobuf/echo_request.pbserver.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  command.mockCommand();

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
        MockService service = MockService();
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
        MockService service = MockService();
        var response = await service.executeWithClient(ctx, EchoAction(), client);
        expect(response, isNull);
      });
    });

    test('should return null when send wrong action to test server', () async {
      config.branch = config.BRANCH_MASTER;
      MockService service = MockService();
      EchoAction action = new EchoAction();
      var response = await service.execute(MockBuildContext(), action);
      expect(response, null);
    });

    test('should mock execute', () async {
      var service = mockServiceTest.MockService()
        ..mockExecute = (ctx, action) async {
          return StringResponse()..text = 'hi';
        };

      EchoAction action = new EchoAction();
      var response = await service.execute(MockBuildContext(), action);
      if (response is StringResponse) {
        expect(response.text, 'hi');
      } else {
        expect(1, 0);
      }
    });

    test('should execute set state', () async {
      var service = mockServiceTest.MockService()
        ..mockExecute = (ctx, action) async {
          return StringResponse()..text = 'hi';
        };

      EchoAction action = new EchoAction();
      Map state = Map();
      await service.execute(MockBuildContext(), action, state: state);
      expect(state['err'], '');
    });

    test('should use shared object', () async {
      var service = mockServiceTest.MockService()
        ..mockExecute = (ctx, action) async {
          return StringResponse()..text = 'hi';
        };

      EchoAction action = new EchoAction();
      var response = await service.execute(MockBuildContext(), action);
      if (response is PbError) {
        expect(response.code, isEmpty);
      } else {
        expect(1, 0);
      }
    });

    test('debugPort should return local test url', () async {
      mockServiceTest.MockService service = mockServiceTest.MockService();
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
