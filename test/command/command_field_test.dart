import 'package:flutter_test/flutter_test.dart';
import '../mock/protobuf/sys_service.pb.dart';
import 'package:libcli/command.dart' as command;
import 'package:libcli/hook.dart' as vars;

void main() {
  command.mock();

  setUp(() {});

  group('[command]', () {
    //!!! testWidgets not allow real http call
    test('should request and get response', () async {
      vars.branch = vars.Branches.test;
      SysService service = SysService();
      var response = await service.dispatch(null, command.PingAction());
      expect(response, isNotNull);
      expect(response.ok, true);
    });
  });
}
