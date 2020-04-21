import 'package:flutter/material.dart';
import 'package:libcli/configuration.dart' as configuration;
import 'package:libcli/command.dart' as command;
import 'package:libcli/utils.dart' as utils;
import 'package:libcli/commands_sys.dart' as commandsSys;

commandsSys.SendAnalyticAction _current = commandsSys.SendAnalyticAction();

saveLog(String where, String message, int level) {
  _current.logs.add(commandsSys.Log()
    ..time = command.Timestamp.fromDateTime(DateTime.now())
    ..app = configuration.appID
    ..user = configuration.userID
    ..where = where
    ..msg = message
    ..level = level);
}

saveError(String where, String message, String stack) {
  _current.errors.add(commandsSys.Error()
    ..msg = message
    ..app = configuration.appID
    ..user = configuration.userID
    ..where = where
    ..stack = '$stack');
}

reset() {
  _current = commandsSys.SendAnalyticAction();
}

@visibleForTesting
current() {
  return _current;
}

///report send analytic to server, return error id if  success others return empty
///
Future<String> sendAnalytic() async {
  if (_current.logs.length > 0 || _current.errors.length > 0) {
    var readyAction = _current;
    readyAction.id = utils.uuid();
    reset();
    commandsSys.SysService service = commandsSys.SysService();
    service.errorHandler = () {}; // ignore error
    var response = await service.execute(null, readyAction);
    if (response.ok) {
      return readyAction.id;
    }
  }
  return '';
}
