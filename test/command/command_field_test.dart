import 'package:flutter_test/flutter_test.dart';
import '../mock/protobuf/sys_service.pb.dart';
import 'package:libcli/command.dart';
import 'package:libcli/configuration.dart' as configuration;

void main() {
  mockCommand();

  setUp(() {});

  group('[command]', () {
    //!!! testWidgets not allow real http call
    test('should request and get response', () async {
      //configuration.branch = configuration.Branches.test;
      SysService service = SysService();
      service.mockExecute = (ctx, obj) async {
        return Err()..code = 0;
      };

      var response = await service.execute(null, PingAction());
      if (response is Err) {
        expect(response.code, OK);
      } else {
        expect(1, 0);
      }
    });
  });
}
