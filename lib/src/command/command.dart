import 'dart:async';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:http/http.dart' as http;
import 'package:libcli/log.dart' as log;
import 'package:libcli/preference.dart' as preference;
import 'package:libcli/src/command/command_protobuf.dart';
import 'package:libcli/src/command/command_url.dart';
import 'package:libcli/src/command/command_http.dart';
import 'package:libcli/command.dart' as shared;

const _here = 'command';

const OK = 0;

bool ok(dynamic response) {
  return response is shared.Err && response.code == OK;
}

/// MockExecuteFunc let test can swap dispatch function in service
///
typedef Future<dynamic> MockExecuteFunc(BuildContext ctx, ProtoObject obj);

/// communicate with server with command using ajax,protobuf and command pattern
/// simplefy the network call to request and response
///
abstract class Service {
  /// remote service url
  ///
  String url;

  /// timeout define request timeout in ms
  final int timeout;

  /// slow define slow network in ms
  ///
  final int slow;

  /// errorHandler override default error handling
  ///
  Function errorHandler;

  set ignoreError(bool value) {
    if (value) {
      errorHandler = () {};
    } else {
      errorHandler = null;
    }
  }

  /// MockExecuteFunc is for test
  ///
  MockExecuteFunc mockExecute;

  /// find object by id
  ///
  ProtoObject newObjectByID(int id, List<int> bytes);

  /// Service create service with remote cloud function name,timeout and slow
  ///
  /// debug port used in debug branch
  Service(String funcName, int debugPort, this.timeout, this.slow) {
    assert(funcName != null && funcName.length > 0);
    url = serviceUrl(funcName, debugPort);
  }

  /// execute action to remote service, no need to handle exception, all exception contract to eventBus
  ///
  ///     service.execute(EchoRequest()).then((response) {
  ///       if(response.ok){
  ///         print(response.data);
  ///       };
  ///     });
  Future<ProtoObject> execute(BuildContext ctx, ProtoObject obj) async {
    if (mockExecute != null) {
      return await mockExecute(ctx, obj);
    }

    assert(url != null && url.length > 0);
    assert(obj != null);
    http.Client client = http.Client();
    return await executeWithClient(ctx, obj, client);
  }

  /// executehWithClient send action to remote service,return object if success, return null if exception happen
  ///
  ///     var response = await service.executehWithClient(client, EchoRequest());
  Future<ProtoObject> executeWithClient(
      BuildContext ctx, ProtoObject obj, http.Client client) async {
    try {
      var jsonSent = log.toString(obj);
      debugPrint('$_here~execute ${obj.runtimeType}$jsonSent to $url');
      Uint8List bytes = encode(obj);
      List<int> ret =
          await post(ctx, client, url, bytes, timeout, slow, errorHandler);
      if (ret != null) {
        ProtoObject retObj = decode(ret, this);
        var jsonReturn = log.toString(retObj);
        debugPrint('$_here~got ${retObj.runtimeType}$jsonReturn from $url');
/*
        if (!kReleaseMode) {


          if (retObj.runtimeType.toString() == ) {
            String type = ' ' + retObj.runtimeType.toString();
            if (type == ' Err') {
              type = '';
            }
          } else {
            log.log('$_here~got ${retObj.runtimeType}=${r.errCode} from $url');
          }
        }*/
        return retObj;
      }
    } catch (e, s) {
      //handle exception here to get better stack trace
      log.sendToGlobalExceptionHanlder(ctx, e, s);
    }
    return null;
  }
}

/// ProtoObject is data transfer object that use ptotobuf format
///
abstract class ProtoObject extends $pb.GeneratedMessage {
  int mapIdXXX();
}

/*
/// Response return data when ok,otherwise check err and errCode
///
class Response {
  /// errCode 0 mean ok and data can be use.
  /// return -1 mean exception throw in request()
  /// other is error from server. using shared.Err
  ///
  int errCode = -1;

  /// errMessage is error message return from server. using shared.Err
  ///
  String errMessage = '';

  /// data is return proto object object
  ///
  ProtoObject data;

  /// setData is return proto object object
  ///
  static Response from(ProtoObject value) {
    assert(value != null);
    Response response = Response();
    if (value is shared.Err) {
      response.errMessage = value.msg;
      response.errCode = value.code;
    } else {
      response.errCode = 0;
    }
    response.data = value;
    return response;
  }

  bool get ok {
    return errCode == 0;
  }
}

Future<Response> get ok async {
  return Response.from(shared.Err()..code = 0);
}
*/
/// mockCommand Initializes the value for testing
///
///     command.mockCommand({});
///
@visibleForTesting
void mockCommand() {
  // ignore:invalid_use_of_visible_for_testing_member
  preference.mockPrefs({});
}
