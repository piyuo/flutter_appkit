import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/command/src/service.dart';
import 'package:libcli/command/src/http.dart';

/// MockExecuteFunc used in test for mock execute function in service
///
typedef MockExecute = Future<pb.Object> Function(BuildContext ctx, pb.Object obj);

/// MockService let you mock service with your own execute function
///
class MockService extends Service {
  MockService({this.mockExecute})
      : super('mock', executer: (
          BuildContext ctx,
          pb.Object command, {
          bool ignoreFirewall = false,
        }) async {
          var f = mockExecute ??
              (_, action) async {
                return pb.OK();
              };
          return await f(ctx, command);
        });

  /// mockExecute mock execute function
  ///
  final MockExecute? mockExecute;

  @override
  pb.Object newObjectByID(int id, List<int> bytes) {
    return pb.OK();
  }
}

Request newRequest(MockClient client) {
  MockService service = MockService();
  return Request(
    service: service,
    client: client,
    action: pb.String(),
    url: 'http://mock',
    timeout: const Duration(milliseconds: 9000),
    slow: const Duration(milliseconds: 9000),
  );
}
