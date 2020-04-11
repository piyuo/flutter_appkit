import 'package:flutter/material.dart';
import 'package:libcli/src/log/commands/sys/analytics_action.pbserver.dart';
import 'package:libcli/src/log/commands/sys/sys_service.pb.dart';
import 'package:libcli/command_type.dart';
import 'package:libcli/configuration.dart' as configuration;

AnalyticsAction _current = AnalyticsAction();

log(String where, String message, int level) {
  Log log = Log();
  log.time = Timestamp.fromDateTime(DateTime.now());
  log.app = configuration.appID;
  log.user = configuration.userID;
  log.where = where;
  log.msg = message;
  log.level = level;
  _current.logs.add(log);
}

error(String where, String message, String stack, String errid) {
  Error error = Error();
  error.msg = message;
  error.app = configuration.appID;
  error.user = configuration.userID;
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
    service.errorHandler = () {}; // ignore error
    var r = await service.dispatch(ctx, readyAction);
    return r.ok;
  }
  return false;
}
