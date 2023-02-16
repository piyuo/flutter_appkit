// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/command/src/events.dart';
import 'package:libcli/command/src/http.dart';
import 'package:libcli/command/src/service.dart';
import 'package:libcli/command/src/protobuf.dart';

void main() {
  group('[downloader_test]', () {
    test('should return object', () async {
      var req = _fakeOkRequest(statusOkMock());
      var obj = await doPost(req, () => pb.OK());
      expect(obj is pb.OK, true);
    });
  });
}
