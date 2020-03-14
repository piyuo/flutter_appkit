import 'package:flutter_test/flutter_test.dart';
import '../mock/protobuf/sys_service.pb.dart';
import 'package:libcli/command/commands/shared/ping_action.pb.dart';
import 'package:libcli/command/command.dart' as command;
import 'package:libcli/hook/vars.dart' as vars;

void main() {
  command.mockInit();

  setUp(() {});

  group('[command]', () {
    //!!! testWidgets not allow real http call
    test('should request and get response', () async {
      vars.Branch = vars.Branches.test;
      SysService service = SysService();
      var response = await service.dispatch(null, PingAction());
      expect(response, isNotNull);
      expect(response.ok, true);
    });
  });
}
