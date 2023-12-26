import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/net/net.dart' as net;

/// Sender define send function use in service, only for test
typedef Sender = Future<net.Object?> Function(net.Object command, {net.Builder? builder});

/// AccessKeyBuilder return access key for action
typedef AccessTokenBuilder = Future<String?> Function();

/// Service communicate with server with command using protobuf and command pattern
/// simplify the network call to request and response
abstract class Service {
  /// Service create service with remote cloud function name,timeout and slow
  /// debug port used in debug branch
  Service(this.serviceName, this._url) : assert(serviceName.isNotEmpty, 'must have service name');

  /// debugPort used debug local service, service url will change to http://localhost:$debugPort
  int? debugPort;

  /// serviceName is remote service name and equal to google cloud run service name
  String serviceName;

  /// timeout define request timeout in ms
  int timeout = 20000;

  /// slow define slow network in ms
  int slow = 10000;

  /// _url keep remote service url
  String _url;

  /// url set remote service url
  set url(value) => _url = value;

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
    return _url;
  }

  /// accessTokenBuilder return access token that action need
  /// ```dart
  /// accessTokenBuilder = () async => null;
  /// ```
  AccessTokenBuilder? accessTokenBuilder;

  /// mock is a test function can set custom send handler for test
  @visibleForTesting
  Sender? mock;

  /// send action to remote service, no need to handle exception, all exception are contract to eventBus
  /// ```dart
  /// var response = await service.send<StringResponse>(EchoAction());
  /// ```
  Future<net.Object?> send(net.Object command, {net.Builder? builder}) async {
    if (!kReleaseMode && mock != null) {
      return mock!(command, builder: builder);
    }
    http.Client client = http.Client();
    return await sendByClient(command, client, builder);
  }

  /// sendByClient send action to remote service,return object if success, return null if exception happen
  /// ```dart
  /// var response = await service.sendByClient(EchoAction());
  /// ```
  Future<net.Object?> sendByClient(net.Object action, http.Client client, net.Builder? builder) async {
    if (net.firewallBegin(action)) {
      log.log('[net] send ${action.jsonString} to $url');
      net.Object? returnObj;
      try {
        returnObj = await net.post(
          net.Request(
            service: this,
            client: client,
            url: url,
            action: action,
            timeout: Duration(milliseconds: timeout),
            slow: Duration(milliseconds: slow),
          ),
          builder,
        );
        return returnObj;
      } finally {
        net.firewallEnd(action);
        if (returnObj != null) {
          log.log('[net] got ${returnObj.jsonString}');
        }
      }
    }
    return null;
  }
}
