import 'dart:async';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:http/http.dart' as http;
import 'package:libcli/log/log.dart';
import 'package:libcli/data/prefs.dart' as prefs;
import 'package:libcli/command/command_protobuf.dart';
import 'package:libcli/command/command_url.dart';
import 'package:libcli/command/command_http.dart';
import 'package:libcli/hook/events.dart';
import 'package:libcli/command/commands/shared/err.pb.dart';

const _here = 'command';

/// communicate with server with command using ajax,protobuf and command pattern
/// simplefy the network call to request and response
///
abstract class Service {
  /// remote service url
  String url;

  /// timeout define request timeout in ms
  final int timeout;

  /// slow define slow network in ms
  final int slow;

  Function onError;

  /// find object by id
  ProtoObject newObjectByID(int id, List<int> bytes);

  /// Service create service with remote cloud function name,timeout and slow
  ///
  /// debug port used in debug branch
  Service(String funcName, int debugPort, this.timeout, this.slow) {
    assert(funcName != null && funcName.length > 0);
    url = serviceUrl(funcName, debugPort);
  }

  /// dispatch request to remote service, no need to handle exception, all exception contract to eventBus
  ///
  ///     service.dispatch(EchoRequest()).then((response) {
  ///       if(response.ok){
  ///         print(response.data);
  ///       };
  ///     });
  Future<dynamic> dispatch(ProtoObject obj) async {
    assert(url != null && url.length > 0);
    assert(obj != null);
    http.Client client = http.Client();
    return dispatchWithClient(obj, client);
  }

  /// dispatchWithClient dispatch request to remote service
  ///
  ///     var response = await service.dispatchWithClient(client, EchoRequest());
  Future<Response> dispatchWithClient(
      ProtoObject obj, http.Client client) async {
    try {
      '$_here|dispatch ${obj.runtimeType} to $url'.log;
      Uint8List bytes = encode(obj);
      List<int> ret = await post(client, url, bytes, timeout, slow, onError);
      if (ret != null) {
        ProtoObject retObj = decode(ret, this);
        var r = Response.from(retObj);
        if (!kReleaseMode) {
          if (r.ok) {
            String type = ' ' + retObj.runtimeType.toString();
            if (type == ' Err') {
              type = '';
            }
            '$_here|got OK $type from $url'.log;
          } else {
            '$_here|got ${retObj.runtimeType}=${r.errCode} from $url'.log;
          }
        }
        return r;
      }
    } catch (e, s) {
      var errId = _here.error(e, s);
      giveup(EError(errId));
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
    if (value is Err) {
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

/// mockInit Initializes the value for testing
///
///     command.mockInit({});
///
@visibleForTesting
void mockInit() {
  prefs.mockInit({});
}
