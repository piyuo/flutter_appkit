import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/log.dart' as log;
import 'package:libcli/command.dart';
import 'package:libpb/pb.dart';

const _here = 'command';

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

  /// errorHandler override default error handling
  ///
  void Function(dynamic error)? errorHandler = null;

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
    if (!kReleaseMode && debugPort != null) {
      timeout = 99999999;
      slow = 99999999;
      return 'http://localhost:$debugPort';
    }
    return serviceUrl(serviceName);
  }

  /// execute action to remote service, no need to handle exception, all exception contract to eventBus
  ///
  ///     var response = await service.execute(EchoAction());
  ///
  Future<ProtoObject?> execute(BuildContext ctx, ProtoObject obj, {Map? state}) async {
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
  Future<ProtoObject?> executeWithClient(BuildContext context, ProtoObject obj, http.Client client) async {
    try {
      var jsonSent = log.toString(obj);
      debugPrint('$_here~${log.STATE}execute ${obj.runtimeType}{$jsonSent}${log.END} to $url');
      Uint8List bytes = encode(obj);
      List<int>? ret = await post(context, client, url, bytes, timeout, slow, errorHandler);
      if (ret != null) {
        ProtoObject retObj = decode(ret, this);
        var jsonReturn = log.toString(retObj);
        debugPrint('$_here~${log.STATE}got ${retObj.runtimeType}{$jsonReturn}${log.END} from $url');
        return retObj;
      }
    } catch (e, s) {
      //handle exception here to get better stack trace
      log.sendToGlobalExceptionHanlder(context, e, s);
    }
    return null;
  }
}
