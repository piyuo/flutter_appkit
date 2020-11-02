import 'package:flutter/material.dart';
import 'package:libcli/app.dart' as configuration;
import 'package:libcli/command.dart' as command;
import 'package:libcli/utils.dart' as utils;
import 'package:libcli/commands_sys.dart' as commandsSys;

commandsSys.SendAnalyticAction _current = commandsSys.SendAnalyticAction();

command.Service _sysService;

@visibleForTesting
set sysService(command.Service service) {
  _sysService = service;
}

command.Service get sysService {
  if (_sysService == null) {
    _sysService = commandsSys.SysService()..ignoreError = true;
  }
  return _sysService;
}

saveLog(String where, String message, int level) {
  _current.logs.add(commandsSys.Log()
    ..time = command.Timestamp.fromDateTime(DateTime.now())
    ..app = configuration.appID
    ..user = configuration.userID
    ..where = where
    ..msg = message
    ..level = level);
}

//todo:add states to commands sys
saveError(String where, String message, String stack, String states) {
  _current.errors.add(
    commandsSys.Error()
      ..msg = message
      ..app = configuration.appID
      ..user = configuration.userID
      ..where = where
      ..stack = stack,
  );
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
    var response = await sysService.execute(null, readyAction);
    if (command.isOK(response)) {
      return readyAction.id;
    }
  }
  return '';
}
