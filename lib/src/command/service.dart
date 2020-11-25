import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/log.dart';
import 'package:libcli/command.dart';
import 'package:libpb/pb.dart' as pb;

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
  pb.ProtoObject newObjectByID(int id, List<int> bytes);

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
  Future<pb.ProtoObject> execute(BuildContext ctx, pb.ProtoObject obj) async {
    http.Client client = http.Client();
    return await executeWithClient(ctx, obj, client);
  }

  /// executehWithClient send action to remote service,return object if success, return null if exception happen
  ///
  ///     var response = await service.executehWithClient(client, EchoAction());
  ///
  Future<pb.ProtoObject> executeWithClient(BuildContext context, pb.ProtoObject obj, http.Client client) async {
    var jsonSent = toLogString(obj);
    log('${COLOR_STATE}send ${obj.runtimeType}{$jsonSent}${COLOR_END} to $url');
    pb.ProtoObject returnObj = await post(
        context,
        Request(
          service: this,
          client: client,
          url: url,
          action: obj,
          timeout: Duration(milliseconds: timeout),
          slow: Duration(milliseconds: slow),
        ));
    var jsonReturn = toLogString(returnObj);
    log('${COLOR_STATE}got ${returnObj.runtimeType}{$jsonReturn}${COLOR_END} from $url');
    return returnObj;
  }
}
