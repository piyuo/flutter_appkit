import 'package:libcli/hook/vars.dart' as vars;
import 'package:libcli/command/commands/sys/analytics_action.pbserver.dart';
import 'package:libcli/command/commands/sys/sys_service.pb.dart';
import 'package:libcli/command/commands/google/timestamp.pb.dart' as timestamp;
import 'package:flutter/material.dart';

AnalyticsAction _current = AnalyticsAction();

log(String where, String message, int level) {
  Log log = Log();
  log.time = timestamp.Timestamp.fromDateTime(DateTime.now());
  log.app = vars.appID;
  log.user = vars.userID;
  log.where = where;
  log.msg = message;
  log.level = level;
  _current.logs.add(log);
}

error(String where, String message, String stack, String errid) {
  Error error = Error();
  error.msg = message;
  error.app = vars.appID;
  error.user = vars.userID;
  error.where = where;
  error.stack = '$stack';
  error.errid = errid;
  _current.errors.add(error);
}

clear() {
  _current = AnalyticsAction();
}

current() {
  return _current;
}

Future<bool> post(BuildContext ctx) async {
  if (_current.logs.length > 0 || _current.errors.length > 0) {
    var readyAction = _current;
    clear();
    SysService service = SysService();
    service.onError = () {}; // ignore error
    var r = await service.dispatch(ctx, readyAction);
    return r.ok;
  }
  return false;
}
