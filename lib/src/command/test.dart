import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/pb.dart' as pb;
import 'package:libcli/src/command/service.dart';
import 'package:libcli/src/command/http.dart';

/// MockExecuteFunc used in test for mock execute function in service
///
typedef MockExecute = Future<pb.Object> Function(BuildContext ctx, pb.Object obj);

/// MockService let you mock service with your own execute function
///
class MockService extends Service {
  /// mockExecute mock execute function
  ///
  final MockExecute? mockExecute;

  MockService({this.mockExecute})
      : super(
          serviceName: 'mock',
          timeout: -1,
          slow: -1,
        );

  @override
  pb.Object newObjectByID(int id, List<int> l) {
    return pb.OK();
  }

  @override
  Future<pb.Object> execute(
    BuildContext ctx,
    pb.Object obj, {
    bool ignoreFirewall = false,
  }) async {
    var f = mockExecute ??
        (_, action) async {
          return pb.OK();
        };
    return await f(ctx, obj);
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
