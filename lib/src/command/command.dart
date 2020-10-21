import 'dart:async';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:http/http.dart' as http;
import 'package:libcli/log.dart' as log;
import 'package:libcli/preference.dart' as preference;
import 'package:libcli/src/command/command-protobuf.dart';
import 'package:libcli/src/command/command-url.dart';
import 'package:libcli/src/command/command-http.dart';
import 'package:libcli/commands/shared/err.pb.dart';
import 'package:libcli/commands/shared/text.pb.dart' as sharedText;
import 'package:libcli/commands/shared/num.pb.dart';
import 'package:libcli/commands/shared/bool.pb.dart';

const _here = 'command';

/// OK is empty string which is mean empty error is OK
///
const OK = '';

/// isOK check if response is Err object and error code is empty
///
bool isOK(dynamic response) {
  return response is Err && response.code.isEmpty;
}

/// ok return Err with OK
///
Err ok() {
  return Err()..code = OK;
}

/// error return Err with error code
///
Err error(String errorCode) {
  return Err()..code = errorCode;
}

/// setErrState set state['err'], null if response is null, '' if response is not null,'error code' if response is err code
///
void setErrState(Map state, ProtoObject response) {
  if (response == null) {
    state['err'] = null;
    return;
  }
  state['err'] = '';
  if (response is Err) {
    state['err'] = response.code;
  }
}

/// text return shared text object
///
sharedText.Text text(String value) {
  return sharedText.Text()..value = value;
}

/// number return shared number object
///
Num number(int value) {
  return Num()..value = value;
}

/// number return shared number object
///
Bool boolean(bool value) {
  return Bool()..value = value;
}

/// communicate with server with command using ajax,protobuf and command pattern
/// simplefy the network call to request and response
///
abstract class Service {
  /// debugPort used debug local service, service url will chnage to http://localhost:$debugPort
  ///
  int debugPort;

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
  Function errorHandler;

  set ignoreError(bool value) {
    if (value) {
      errorHandler = () {};
    } else {
      errorHandler = null;
    }
  }

  /// find object by id
  ///
  ProtoObject newObjectByID(int id, List<int> bytes);

  /// Service create service with remote cloud function name,timeout and slow
  ///
  /// debug port used in debug branch
  Service(this.serviceName, this.timeout, this.slow) {
    assert(serviceName != null && serviceName.length > 0);
  }

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
  Future<ProtoObject> execute(BuildContext ctx, ProtoObject obj) async {
    assert(obj != null);
    http.Client client = http.Client();
    return await executeWithClient(ctx, obj, client);
  }

  /// executehWithClient send action to remote service,return object if success, return null if exception happen
  ///
  ///     var response = await service.executehWithClient(client, EchoAction());
  Future<ProtoObject> executeWithClient(BuildContext ctx, ProtoObject obj, http.Client client) async {
    try {
      var jsonSent = log.toString(obj);
      debugPrint('$_here~${log.STATE}execute ${obj.runtimeType}{$jsonSent}${log.END} to $url');
      Uint8List bytes = encode(obj);
      List<int> ret = await post(ctx, client, url, bytes, timeout, slow, errorHandler);
      if (ret != null) {
        ProtoObject retObj = decode(ret, this);
        var jsonReturn = log.toString(retObj);
        debugPrint('$_here~${log.STATE}got ${retObj.runtimeType}{$jsonReturn}${log.END} from $url');
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

/// mockCommand Initializes the value for testing
///
///     command.mockCommand({});
///
@visibleForTesting
void mockCommand() {
  // ignore:invalid_use_of_visible_for_testing_member
  preference.mockPrefs({});
}
