import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/command.dart' as command;
import 'package:libcli/app.dart' as config;
import 'package:libcli/src/command/mock-service.dart';
import 'package:libcli/mock/protobuf/string_response.pbserver.dart';
import 'package:libcli/mock/protobuf/echo_request.pbserver.dart';
import 'package:libcli/mock/protobuf/sample_service.pb.dart';
import 'package:libpb/pb.dart' as pb;

void main() {
  setUp(() {});

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
      expect(response is pb.PbEmpty, true);
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
  });
}
