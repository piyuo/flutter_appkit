import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:flutter/material.dart';
import 'package:libcli/command.dart';
import 'package:mockito/mockito.dart';
import 'package:libpb/pb.dart' as pb;

/// MockExecuteFunc used in test for mock execute function in service
///
typedef Future<pb.ProtoObject> MockExecute(BuildContext ctx, pb.ProtoObject obj);

/// MockService let you mock service with your own execute function
///
class MockService extends Service {
  /// mockExecute mock execute function
  ///
  MockExecute mockExecute = (_, action) async {
    return ok();
  };

  MockService()
      : super(
          serviceName: 'mock',
          timeout: -1,
          slow: -1,
        );

  @override
  pb.ProtoObject newObjectByID(int id, List<int> l) {
    return ok();
  }

  @override
  Future<pb.ProtoObject> execute(BuildContext ctx, pb.ProtoObject obj) async {
    return await mockExecute(ctx, obj);
  }
}

class MockBuildContext extends Mock implements BuildContext {}

Request newRequest(MockClient client) {
  MockService service = MockService();
  return Request(
    service: service,
    client: client,
    action: pb.PbString(),
    url: 'http://mock',
    timeout: Duration(milliseconds: 9000),
    slow: Duration(milliseconds: 9000),
  );
}
