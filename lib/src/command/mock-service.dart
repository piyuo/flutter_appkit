import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/src/command/service.dart';
import 'package:libcli/src/command/http.dart';
import 'package:libcli/src/command/guard.dart';
import 'package:libpb/pb.dart';

/// MockExecuteFunc used in test for mock execute function in service
///
typedef Future<PbObject> MockExecute(BuildContext ctx, PbObject obj);

/// MockService let you mock service with your own execute function
///
class MockService extends Service {
  /// mockExecute mock execute function
  ///
  MockExecute mockExecute = (_, action) async {
    return PbOK();
  };

  MockService()
      : super(
          serviceName: 'mock',
          timeout: -1,
          slow: -1,
        );

  @override
  PbObject newObjectByID(int id, List<int> l) {
    return PbOK();
  }

  @override
  Future<PbObject> execute(
    BuildContext ctx,
    PbObject obj, {
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
    action: PbString(),
    url: 'http://mock',
    timeout: Duration(milliseconds: 9000),
    slow: Duration(milliseconds: 9000),
  );
}
