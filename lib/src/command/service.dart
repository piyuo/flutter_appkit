import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/log.dart';
import 'package:libcli/command.dart';
import 'package:libpb/pb.dart';

/// communicate with server with command using ajax,protobuf and command pattern
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
  ProtoObject newObjectByID(int id, List<int> bytes);

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

  /// execute action to remote service, no need to handle exception, all exception contract to eventBus
  ///
  ///     var response = await service.execute(EchoAction());
  ///
  Future<ProtoObject> execute(BuildContext ctx, ProtoObject obj, {Map? state}) async {
    http.Client client = http.Client();
    var response = await executeWithClient(ctx, obj, client);
    if (state != null) {
      setErrState(state, response);
    }
    return response;
  }

  /// executehWithClient send action to remote service,return object if success, return null if exception happen
  ///
  ///     var response = await service.executehWithClient(client, EchoAction());
  ///
  Future<ProtoObject> executeWithClient(BuildContext context, ProtoObject obj, http.Client client) async {
    var jsonSent = toLogString(obj);
    log('${COLOR_STATE}send ${obj.runtimeType}{$jsonSent}${COLOR_END} to $url');
    ProtoObject returnObj = await post(context, this, client, url, obj, timeout, slow);
    var jsonReturn = toLogString(returnObj);
    log('${COLOR_STATE}got ${returnObj.runtimeType}{$jsonReturn}${COLOR_END} from $url');
    return returnObj;
  }
}
