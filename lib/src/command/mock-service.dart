import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/command.dart';

/// MockExecuteFunc used in test for mock execute function in service
///
typedef Future<ProtoObject> MockExecute(BuildContext ctx, ProtoObject obj);

/// MockService let you mock service with your own execute function
///
class MockService extends Service {
  /// mockExecute mock execute function
  ///
  MockExecute mockExecute;

  MockService(this.mockExecute) : super('mock', -1, -1);

  @override
  ProtoObject newObjectByID(int id, List<int> l) {
    return null;
  }

  @override
  Future<ProtoObject> execute(BuildContext ctx, ProtoObject obj, {Map state}) async {
    var response = await mockExecute(ctx, obj);
    if (state != null) {
      setErrState(state, response);
    }
    return response;
  }
}
