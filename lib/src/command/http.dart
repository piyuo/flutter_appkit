import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/log.dart' as log;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/src/command/events.dart';
import 'package:libcli/src/command/http-header.dart';

const _here = 'command_http';

///Request for reuest(),let test more easily
class Request {
  http.Client client;
  String url;
  Uint8List bytes;
  int timeout;
  Future<bool> Function()? isInternetConnected;
  Future<bool> Function()? isGoogleCloudFunctionAvailable;
  void Function(dynamic error)? errorHandler;
  Request({
    required this.client,
    required this.url,
    required this.bytes,
    required this.timeout,
    this.isInternetConnected,
    this.isGoogleCloudFunctionAvailable,
    this.errorHandler,
  });
}

/// post call request() and broadcast network slow if request time is longer than slow
///
///     await commandHttp.postclient, '', bytes, 500, 1);
///     expect(listener.latestEvent is contract.EventNetworkSlow, true);
Future<List<int>?> post(
  BuildContext ctx,
  http.Client client,
  String url,
  Uint8List bytes,
  int timeout,
  int slow,
  void Function(dynamic error)? errorHandler,
) async {
  Completer<List<int>> completer = new Completer<List<int>>();
  var timer = Timer(Duration(milliseconds: slow), () {
    if (!completer.isCompleted && errorHandler == null) {
      eventbus.broadcast(ctx, SlowNetworkEvent());
    }
  });
  Request req = Request(
    client: client,
    url: url,
    bytes: bytes,
    timeout: timeout,
    errorHandler: errorHandler,
  );
  doPost(ctx, req).then((response) {
    timer.cancel();
    completer.complete(response);
  });
  // no need to catch error since doPost() catch all exception
  return completer.future;
}

///doPost  send action bytes to remote url and return response bytes, this function will use contract to fix error
///
///     var req = commandHttp.Request();
///     req.client = client;
///     req.bytes = Uint8List(2);
///     req.url = 'http://mock';
///     req.timeout = 9000;
///     var bytes = await commandHttp.doPost(req);
///
Future<List<int>?> doPost(BuildContext context, Request r) async {
  try {
    var headers = await doRequestHeaders();
    var resp = await r.client.post(r.url, headers: headers, body: r.bytes).timeout(Duration(milliseconds: r.timeout));
    await doResponseHeaders(resp.headers);

    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    }

    if (emmitError(r, resp.statusCode)) {
      return null;
    }

    var msg = '${resp.statusCode} ${resp.body} from ${r.url}';
    log.warning('$_here~caught $msg');
    switch (resp.statusCode) {
      case 500: //internal server error
        return giveup(context, InternalServerErrorEvent()); //body is err id
      case 501: //the remote servie is not properly setup
        return giveup(context, ServerNotReadyEvent()); //body is err id
      case 504: //service context deadline exceeded
        return await retry(
          context,
          contract: RequestTimeoutContract(
            isServer: true,
            errorID: resp.body,
            url: r.url,
          ),
          request: r,
        ); //body is err id
      case 511: //access token required
        return await retry(
          context,
          contract: CAccessTokenRequired(),
          fail: ERefuseSignin(),
          request: r,
        );
      case 412: //access token expired
        return await retry(
          context,
          contract: CAccessTokenExpired(),
          fail: ERefuseSignin(),
          request: r,
        );
      case 402: //payment token expired
        return await retry(
          context,
          contract: CPaymentTokenRequired(),
          fail: ERefuseSignin(),
          request: r,
        );
      case 400: //bad request
        return giveup(context, BadRequestEvent()); //body is err id
    }
    //unknow status code
    throw Exception('unknown status ' + msg);
  } on SocketException catch (e) {
    if (emmitError(r, e)) {
      return null;
    }
    log.warning('$_here~failed to connect ${r.url} cause $e');
    return await retry(context, contract: InternetRequiredContract(exception: e, url: r.url), request: r);
  } on TimeoutException catch (e) {
    if (emmitError(r, e)) {
      return null;
    }
    log.warning('$_here~connection timeout ${r.url} cause $e');
    return await retry(context,
        contract: RequestTimeoutContract(isServer: false, exception: e, url: r.url), request: r);
  } catch (e, s) {
    //handle exception here to get better stack trace
    if (emmitError(r, e)) {
      return null;
    }
    log.error(_here, '$e, url: ${r.url}', s);
    log.sendToGlobalExceptionHanlder(context, e, s);
    return null;
  }
}

/// emmitError return true if send error to custom error handler
///
///     emmitError(request);
///
bool emmitError(Request r, dynamic error) {
  if (r.errorHandler != null) {
    r.errorHandler!(error);
    return true;
  }
  return false;
}

/// giveup brodcast event then return null
///
///     commandHttp.giveup(ctx,BadRequestEvent());
///
giveup(BuildContext ctx, dynamic e) {
  eventbus.broadcast(ctx, e);
}

/// retry use contract, broadcast event when failed
///
///     await commandHttp.retry(ctx,c.CAccessTokenExpired(), c.ERefuseSignin(), req);
///
Future<List<int>?> retry(
  BuildContext context, {
  required eventbus.Contract contract,
  required Request request,
  dynamic? fail,
}) async {
  if (await eventbus.contract(context, contract)) {
    log.log('$_here~ok,retry');
    return await doPost(context, request);
  }
  if (fail != null) {
    eventbus.broadcast(context, fail);
  }
  return null;
}
