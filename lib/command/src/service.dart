import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'firewall.dart';
import 'http.dart';

/// Sender define send function use in service, only for test
typedef Sender = Future<pb.Object> Function(pb.Object command, {pb.Builder? builder});

/// AccessKeyBuilder return access key for action
typedef AccessTokenBuilder = Future<String?> Function();

/// Service communicate with server with command using protobuf and command pattern
/// simplify the network call to request and response
abstract class Service {
  /// Service create service with remote cloud function name,timeout and slow
  /// debug port used in debug branch
  Service(this.serviceName) {
    assert(serviceName.isNotEmpty, 'must have service name');
  }

  /// debugPort used debug local service, service url will change to http://localhost:$debugPort
  int? debugPort;

  /// serviceName is remote service name and equal to google cloud run service name
  String serviceName;

  /// timeout define request timeout in ms
  int timeout = 20000;

  /// slow define slow network in ms
  int slow = 10000;

  /// ignoreFirewall is true will ignore firewall check
  bool ignoreFirewall = false;

  /// url return remote service url
  /// ```dart
  /// url; // https://auth-us.piyuo.com , https://auth-us-master.piyuo.com
  /// ```
  String get url {
    if (!kReleaseMode) {
      if (debugPort != null) {
        timeout = 99999999;
        slow = 99999999;
        return 'http://localhost:$debugPort';
      }
    }
    assert(urlBuilder != null, 'urlBuilder must not be null');
    assert(accessTokenBuilder != null, 'accessKeyBuilder should not be null');
    assert(acceptLanguage != null, 'acceptLanguage should not be null');
    //String region = regionBuilder != null ? '-${regionBuilder!()}' : '';
    //String branch = branchBuilder != null ? '-${branchBuilder!()}' : '';
    //return 'https://$serviceName$region$branch.$baseDomain/?q'; // add ? to avoid cache
    //import 'package:libcli/command/src/url.dart';
    return urlBuilder!();
  }

  /// accessTokenBuilder return access token that action need
  /// ```dart
  /// accessTokenBuilder = () async => null;
  /// ```
  AccessTokenBuilder? accessTokenBuilder;

  /// urlBuilder return region that action need
  /// ```dart
  /// urlBuilder = () => 'http://mock';
  /// ```
  String Function()? urlBuilder;

  /// acceptLanguage set the locale the remote service use
  /// ```dart
  /// acceptLanguage = () => 'en-US';
  /// ```
  String Function()? acceptLanguage;

  /// mockSender is a test function can set custom send handler for test
  Sender? mockSender;

  /// send action to remote service, no need to handle exception, all exception are contract to eventBus
  /// ```dart
  /// var response = await service.send(EchoAction());
  /// ```
  Future<pb.Object> send(pb.Object command, {pb.Builder? builder}) async {
    if (!kReleaseMode && mockSender != null) {
      return mockSender!(command, builder: builder);
    }
    http.Client client = http.Client();
    return await sendByClient(command, client, builder);
  }

  /// sendByClient send action to remote service,return object if success, return null if exception happen
  /// ```dart
  /// var response = await service.sendByClient(EchoAction());
  /// ```
  Future<pb.Object> sendByClient(pb.Object action, http.Client client, pb.Builder? builder) async {
    dynamic result = FirewallPass;
    if (!ignoreFirewall) {
      result = firewallBegin(action);
    }
    if (result is FirewallPass) {
      log.log('[command] send ${action.jsonString} to $url');
      pb.Object? returnObj;
      try {
        returnObj = await post(
            Request(
              service: this,
              client: client,
              url: url,
              action: action,
              timeout: Duration(milliseconds: timeout),
              slow: Duration(milliseconds: slow),
            ),
            builder);
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
      eventbus.broadcast(FirewallBlockEvent(result.reason));
      return result;
    }
    //cached object
    log.log('[command] send ${action.jsonString} to $url and return cache ${result.jsonString}');
    return result;
  }
}
