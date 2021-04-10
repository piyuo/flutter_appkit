import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/src/log/log.dart';
import 'package:libcli/src/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/src/command/guard.dart';
import 'package:libcli/src/command/url.dart';
import 'package:libcli/src/command/http.dart';
import 'package:libcli/src/command/events.dart';
import 'package:libpb/pb.dart';

/// Service communicate with server with command using protobuf and command pattern
/// simplefy the network call to request and response
///
abstract class Service {
  /// debugPort used debug local service, service url will chnage to http://localhost:$debugPort
  ///
  int? debugPort;

  /// serviceName is remote service name and equal to google cloud run service name
  ///
  String serviceName;

  /// timeout define request timeout in ms
  ///
  int timeout;

  /// slow define slow network in ms
  ///
  int slow;

  /// Service create service with remote cloud function name,timeout and slow
  ///
  /// debug port used in debug branch
  ///
  Service({
    required this.serviceName,
    required this.timeout,
    required this.slow,
    this.debugPort,
  }) {
    assert(serviceName.length > 0, 'must have service name');
  }

  /// find object by id
  ///
  PbObject newObjectByID(int id, List<int> bytes);

  /// url return remote service url
  ///
  String get url {
    if (!kReleaseMode) {
      if (debugPort != null) {
        timeout = 99999999;
        slow = 99999999;
        return 'http://localhost:$debugPort';
      }
    }
    return serviceUrl(serviceName);
  }

  /// execute command to remote service, no need to handle exception, all exception contract to eventBus
  ///
  ///     var response = await service.execute(EchoAction());
  ///
  Future<PbObject> execute(
    BuildContext ctx,
    PbObject command, {
    GuardRule? rule,
    bool broadcastDenied = true,
  }) async {
    http.Client client = http.Client();
    return await executeWithClient(
      ctx,
      command,
      client,
      rule: rule,
      broadcastDenied: broadcastDenied,
    );
  }

  /// executehWithClient send command to remote service,return object if success, return null if exception happen
  ///
  ///     var response = await service.executehWithClient(client, EchoAction());
  ///
  Future<PbObject> executeWithClient(
    BuildContext context,
    PbObject command,
    http.Client client, {
    GuardRule? rule,
    bool broadcastDenied = true,
  }) async {
    rule = rule ?? DefaultGuardRule;
    var result = guardCheck(command.runtimeType, rule);
    if (result == 0) {
      //pass
      var jsonSent = toLogString(command);
      log('${COLOR_STATE}send ${command.runtimeType}{$jsonSent}${COLOR_END} to $url');
      PbObject returnObj = await post(
          context,
          Request(
            service: this,
            client: client,
            url: url,
            action: command,
            timeout: Duration(milliseconds: timeout),
            slow: Duration(milliseconds: slow),
          ));
      var jsonReturn = toLogString(returnObj);
      log('${COLOR_STATE}got ${returnObj.runtimeType}{$jsonReturn}${COLOR_END} from $url');
      return returnObj;
    }

    var duration = result == 1 ? rule.duration1! : rule.duration2!;
    var count = result == 1 ? rule.count1! : rule.count2!;
    log('${COLOR_ALERT}send ${command.runtimeType} denied${COLOR_END} $count/$duration');

    if (broadcastDenied) {
      eventbus.broadcast(context, GuardDeniedEvent());
    }
    return PbError()..code = 'GUARD_$result';
  }
}
