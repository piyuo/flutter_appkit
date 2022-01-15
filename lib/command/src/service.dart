import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/command/src/firewall.dart';
import 'package:libcli/command/src/url.dart';
import 'package:libcli/command/src/http.dart';

/// Sender define send function use in service, only for test
typedef Sender = Future<pb.Object> Function(BuildContext context, pb.Object command);

/// Service communicate with server with command using protobuf and command pattern
/// simplify the network call to request and response
///
abstract class Service {
  /// Service create service with remote cloud function name,timeout and slow
  ///
  /// debug port used in debug branch
  ///
  Service(
    this.serviceName, {
    Sender? sender,
  }) {
    assert(serviceName.isNotEmpty, 'must have service name');
    send = sender ??
        (BuildContext ctx, pb.Object command) async {
          http.Client client = http.Client();
          return await sendByClient(ctx, command, client);
        };
  }

  /// debugPort used debug local service, service url will change to http://localhost:$debugPort
  ///
  int? debugPort;

  /// serviceName is remote service name and equal to google cloud run service name
  ///
  String serviceName;

  /// timeout define request timeout in ms
  ///
  int timeout = 20000;

  /// slow define slow network in ms
  ///
  int slow = 10000;

  /// ignoreFirewall is true will ignore firewall check
  ///
  bool ignoreFirewall = false;

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

  /// send action to remote service, no need to handle exception, all exception are contract to eventBus
  ///
  ///     var response = await service.send(EchoAction());
  ///
  late Sender send;

  /// sendByClient send action to remote service,return object if success, return null if exception happen
  ///
  ///     var response = await service.sendByClient(client, EchoAction());
  ///
  Future<pb.Object> sendByClient(BuildContext context, pb.Object action, http.Client client) async {
    dynamic result = FirewallPass;
    if (!ignoreFirewall) {
      result = firewallBegin(action);
    }
    if (result is FirewallPass) {
      log.log('[command] send ${action.jsonString} to $url');
      pb.Object? returnObj;
      try {
        returnObj = await post(
            context,
            Request(
              service: this,
              client: client,
              url: url,
              action: action,
              timeout: Duration(milliseconds: timeout),
              slow: Duration(milliseconds: slow),
            ));
        return returnObj;
      } finally {
        if (!ignoreFirewall) {
          firewallEnd(action, returnObj);
        }
        if (returnObj != null) {
          log.log('[command] got ${returnObj.jsonString}');
        } else {
          log.log('[command] failed to send');
        }
      }
    } else if (result is FirewallBlock) {
      log.log('[command] block ${result.reason} ${action.jsonString}');
      eventbus.broadcast(context, FirewallBlockEvent(result.reason));
      return result;
    }
    //cached object
    log.log('[command] send ${action.jsonString} to $url and return cache ${result.jsonString}');
    return result;
  }
}
