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
import 'package:libcli/eventbus.dart' as eventbus;

const _here = 'command';

/// DispatchFunc let test can swap dispatch function in service
///
typedef Future<dynamic> MockDispatchFunc(BuildContext ctx, ProtoObject obj);

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

  /// mockDispatch function is for test
  ///
  MockDispatchFunc mockExecute;

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

  /// execute request to remote service, no need to handle exception, all exception contract to eventBus
  ///
  ///     service.execute(EchoRequest()).then((response) {
  ///       if(response.ok){
  ///         print(response.data);
  ///       };
  ///     });
  Future<Response> execute(BuildContext ctx, ProtoObject obj) async {
    if (mockExecute != null) {
      return await mockExecute(ctx, obj);
    }

    assert(url != null && url.length > 0);
    assert(obj != null);
    http.Client client = http.Client();
    return await executehWithClient(ctx, obj, client);
  }

  /// executehWithClient dispatch request to remote service
  ///
  ///     var response = await service.executehWithClient(client, EchoRequest());
  Future<Response> executehWithClient(
      BuildContext ctx, ProtoObject obj, http.Client client) async {
    try {
      log.log('$_here~dispatch ${obj.runtimeType} to $url');
      Uint8List bytes = encode(obj);
      List<int> ret =
          await post(ctx, client, url, bytes, timeout, slow, errorHandler);
      if (ret != null) {
        ProtoObject retObj = decode(ret, this);
        var r = Response.from(retObj);
        if (!kReleaseMode) {
          if (r.ok) {
            String type = ' ' + retObj.runtimeType.toString();
            if (type == ' Err') {
              type = '';
            }
            log.log('$_here~got OK $type from $url');
          } else {
            log.log('$_here~got ${retObj.runtimeType}=${r.errCode} from $url');
          }
        }
        return r;
      }
    } catch (e, s) {
      var errID = log.error(_here, e, s);
      giveup(ctx, eventbus.UnknownErrorEvent(errID));
    }
    return Response();
  }
}

/// ProtoObject is data transfer object that use ptotobuf format
///
abstract class ProtoObject extends $pb.GeneratedMessage {
  int mapIdXXX();
}

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

/// mockCommand Initializes the value for testing
///
///     command.mockCommand({});
///
@visibleForTesting
void mockCommand() {
  // ignore:invalid_use_of_visible_for_testing_member
  preference.mockPrefs({});
}
