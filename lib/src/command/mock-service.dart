import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/src/command/service.dart';
import 'package:libcli/src/command/http.dart';
import 'package:libcli/src/command/guard.dart';
import 'package:libpb/src/pb/pb.dart' as pb;

/// MockExecuteFunc used in test for mock execute function in service
///
typedef Future<pb.Object> MockExecute(BuildContext ctx, pb.Object obj);

/// MockService let you mock service with your own execute function
///
class MockService extends Service {
  /// mockExecute mock execute function
  ///
  MockExecute mockExecute = (_, action) async {
    return pb.OK();
  };

  MockService()
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
    GuardRule? rule,
    bool broadcastDenied = true,
  }) async {
    return await mockExecute(ctx, obj);
  }
}

Request newRequest(MockClient client) {
  MockService service = MockService();
  return Request(
    service: service,
    client: client,
    action: pb.String(),
    url: 'http://mock',
    timeout: Duration(milliseconds: 9000),
    slow: Duration(milliseconds: 9000),
  );
}
