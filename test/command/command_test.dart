import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/command.dart' as command;
import 'package:libcli/command_type.dart';
import 'package:libcli/common.dart' as configuration;
import '../mock.dart';
import '../mock/protobuf/sys_service.pb.dart';
import '../mock/protobuf/string_response.pbserver.dart';
import '../mock/protobuf/echo_request.pbserver.dart';

void main() {
  command.mockCommand();

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
        var response =
            await service.dispatchWithClient(ctx, EchoRequest(), client);
        expect(response.ok, true);
        expect((response.data as StringResponse).text, 'hi');
      });
    });

    testWidgets('should receive null', (WidgetTester tester) async {
      var client = MockClient((request) async {
        return http.Response('', 501);
      });

      await tester.inWidget((ctx) async {
        SysService service = SysService();
        var response =
            await service.dispatchWithClient(ctx, EchoRequest(), client);
        expect(response.ok, false);
      });
    });

    test('should return null when send wrong action to test server', () async {
      configuration.branch = configuration.Branches.test;
      SysService service = SysService();
      EchoRequest action = new EchoRequest();
      var response = await service.dispatch(null, action);
      expect(response.ok, false);
      expect(response.data, null);
    });

    test('should return ok when is not Err response', () async {
      var protoObject = StringResponse();
      var response = command.Response.from(protoObject);
      expect(response.ok, true);
      expect(response.data, protoObject);
    });

    test('should return error response', () async {
      var err = Err()
        ..code = 1
        ..msg = 'mock_error';
      var response = command.Response.from(err);
      expect(response.ok, false);
      expect(response.data is Err, true);
    });

    test('should return ok response', () async {
      var err = Err()..code = 0;
      var response = command.Response.from(err);
      expect(response.ok, true);
      expect(response.data is Err, true);
    });

    test('should mock dispatch', () async {
      SysService service = SysService();
      service.mockDispatch = (ctx, obj) async {
        var data = StringResponse();
        data.text = 'hi';
        return command.Response()
          ..data = data
          ..errCode = -3;
      };

      EchoRequest action = new EchoRequest();
      var response = await service.dispatch(null, action);
      expect(response.errCode, -3);
      StringResponse returnData = response.data as StringResponse;
      expect(returnData.text, 'hi');
    });
  });
}
