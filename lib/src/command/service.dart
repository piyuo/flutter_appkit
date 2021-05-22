import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:libpb/pb.dart' as pb;
import 'package:libcli/log.dart' as log;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/src/command/firewall.dart';
import 'package:libcli/src/command/url.dart';
import 'package:libcli/src/command/http.dart';

/// Service communicate with server with command using protobuf and command pattern
/// simplify the network call to request and response
///
abstract class Service {
  /// debugPort used debug local service, service url will change to http://localhost:$debugPort
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
  pb.Object newObjectByID(int id, List<int> bytes);

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
  Future<pb.Object> execute(
    BuildContext ctx,
    pb.Object command, {
    bool ignoreFirewall = false,
  }) async {
    http.Client client = http.Client();
    return await executeWithClient(
      ctx,
      command,
      client,
      ignoreFirewall: ignoreFirewall,
    );
  }

  /// executeWithClient send command to remote service,return object if success, return null if exception happen
  ///
  ///     var response = await service.executeWithClient(client, EchoAction());
  ///
  Future<pb.Object> executeWithClient(
    BuildContext context,
    pb.Object command,
    http.Client client, {
    bool ignoreFirewall = false,
  }) async {
    final commandJSON = command.jsonString;
    dynamic result = FirewallPass;
    if (!ignoreFirewall) {
      result = firewall(commandJSON);
    }
    if (result is FirewallPass) {
      log.log('${log.COLOR_STATE}send $commandJSON${log.COLOR_END} to $url');
      pb.Object? returnObj = null;
      try {
        returnObj = await post(
            context,
            Request(
              service: this,
              client: client,
              url: url,
              action: command,
              timeout: Duration(milliseconds: timeout),
              slow: Duration(milliseconds: slow),
            ));
        return returnObj;
      } finally {
        if (!ignoreFirewall) {
          firewallPostComplete(commandJSON, returnObj);
        }
        if (returnObj != null) {
          log.log('${log.COLOR_STATE}got ${returnObj.jsonString}${log.COLOR_END}');
        } else {
          log.log('${log.COLOR_ALERT}failed to send');
        }
      }
    } else if (result is FirewallBlock) {
      log.log('${log.COLOR_ALERT}block ${result.reason} ${command.jsonString}${log.COLOR_END}');
      eventbus.broadcast(context, FirewallBlockEvent());
      return result;
    }
    //cached object
    log.log('${log.COLOR_STATE}send $commandJSON${log.COLOR_END} to $url');
    log.log('${log.COLOR_WARNING}return cache ${result.jsonString}${log.COLOR_END}');
    return result;
  }
}
