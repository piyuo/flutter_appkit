import 'dart:async';
import 'dart:typed_data';
import 'package:libcli/log/log.dart' as log;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:http/http.dart' as http;
import 'command_protobuf.dart';
import 'command_url.dart';
import 'command_http.dart';
import 'package:libcli/contract/contract.dart' as c;
import 'package:libcli/command/commands/shared/err.pb.dart';

const _here = 'command';

///ProtoObject is data transfer object that use ptotobuf format
abstract class ProtoObject extends $pb.GeneratedMessage {
  int mapIdXXX();
}

///Response return data when ok,otherwise check err and errCode
class Response {
  bool ok = false;
  String err = '';
  int errCode = 0;
  ProtoObject data;

  Response(this.data) {
    if (this.data != null) {
      if (this.data is Err) {
        var e = this.data as Err;
        err = e.msg;
        errCode = e.code;
        if (errCode == 0) {
          ok = true;
        }
      } else {
        ok = true;
      }
    }
  }
}

/// communicate with server with command using ajax,protobuf and command pattern
/// it basically send a action command and receive response command
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
    url = serviceUrl(funcName, debugPort);
  }

  /// request send command and return result, return null when something wrong
  ///

  ///     EchoAction echoAction = new EchoAction();
  ///     echoAction.text = 'helloWorld';
  ///     service.send(echoAction).then((result) {
  ///       if(result != null){};
  ///     });
  Future<dynamic> request(ProtoObject obj) async {
    assert(url != null && url.length > 0);
    http.Client client = http.Client();
    return requestWithClient(client, obj);
  }

  /// requestWithClient send command using client
  ///
  ///     var response = await service.sendWithClient(client, action);
  ///     expect(response.ok, true);
  Future<Response> requestWithClient(
      http.Client client, ProtoObject obj) async {
    Response rNull = Response(null);
    try {
      log.debug(_here, 'send ${obj.runtimeType} to $url');
      Uint8List bytes = encode(obj);
      List<int> ret = await post(client, url, bytes, timeout, slow, onError);
      if (ret != null) {
        ProtoObject retObj = decode(ret, this);
        var r = Response(retObj);
        if (r.ok) {
          String type = ' ' + retObj.runtimeType.toString();
          if (type == ' Err') {
            type = '';
          }
          log.debug(_here, 'got OK$type  from $url');
        } else {
          log.debug(_here, 'got ${retObj.runtimeType}=${r.errCode} from $url');
        }
        return r;
      }
    } catch (e, s) {
      var errId = log.error(_here, e, s);
      giveup(c.EError(errId));
      return rNull;
    }
    log.debugWarning(_here, 'got NULL from $url');
    return rNull;
  }
}
