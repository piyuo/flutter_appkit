import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/log.dart' as log;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/src/command/events.dart';
import 'package:libcli/src/command/auth.dart' as auth;

const _here = 'command_http';

///Request for reuest(),let test more easily
class Request {
  http.Client client;
  String url;
  Uint8List bytes;
  int timeout;
  Future<bool> Function() isInternetConnected;
  Future<bool> Function() isGoogleCloudFunctionAvailable;
  Function errorHandler;
}

/// post call request() and broadcast network slow if request time is longer than slow
///
///     await commandHttp.postclient, '', bytes, 500, 1);
///     expect(listener.latestEvent is contract.EventNetworkSlow, true);
Future<List<int>> post(BuildContext ctx, http.Client client, String url,
    Uint8List bytes, int timeout, int slow, Function errorHandler) async {
  Completer<List<int>> completer = new Completer<List<int>>();
  var timer = Timer(Duration(milliseconds: slow), () {
    if (!completer.isCompleted && errorHandler == null) {
      eventbus.broadcast(ctx, NetworkSlowEvent());
    }
  });
  Request req = Request();
  req.client = client;
  req.url = url;
  req.bytes = bytes;
  req.timeout = timeout;
  req.errorHandler = errorHandler;
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
Future<List<int>> doPost(BuildContext ctx, Request r) async {
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'accept': '',
  };

  var accessToken = await auth.getAccessToken();
  if (accessToken.length > 0) {
    debugPrint('$_here~accessToken=$accessToken');
    headers['Cookie'] = accessToken;
  }

  try {
    var resp = await r.client
        .post(r.url, headers: headers, body: r.bytes)
        .timeout(Duration(milliseconds: r.timeout));

    var c = resp.headers['set-cookie'];
    if (c != null && c.length > 0) {
      debugPrint('$_here~refresh accessToken=$c');
      auth.setAccessToken(c);
    }

    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    }

    if (r.errorHandler != null) {
      return emmitError(r);
    }
    var msg = '${resp.statusCode} ${resp.body} from ${r.url}';
    log.log('$_here~caught $msg');
    switch (resp.statusCode) {
      case 500: //internal server error
        return giveup(ctx, ServerInternalErrorEvent()); //body is err id
      case 501: //the remote servie is not properly setup
        return giveup(ctx, ServerNeedSetupEvent()); //body is err id
      case 504: //service context deadline exceeded
        return giveup(
            ctx, NetworkDeadlineExceedEvent(resp.body)); //body is err id
      case 511: //access token required
        return await retry(ctx,
            contract: CAccessTokenRequired(),
            fail: ERefuseSignin(),
            request: r);
      case 412: //access token expired
        return await retry(ctx,
            contract: CAccessTokenExpired(), fail: ERefuseSignin(), request: r);
      case 402: //payment token expired
        return await retry(ctx,
            contract: CPaymentTokenRequired(),
            fail: ERefuseSignin(),
            request: r);
      case 400: //bad request
        return giveup(ctx, ServerBadRequest()); //body is err id
    }
    //unknow status code
    throw Exception('unknown status ' + msg);
  } on SocketException catch (e, s) {
    if (r.errorHandler != null) {
      return emmitError(r);
    }
    log.error(_here, 'failed to connect ${r.url} cause $e', s);
    return await retry(ctx,
        contract: InternetRequiredContract(exception: e, url: r.url),
        request: r);
  } on TimeoutException catch (e, s) {
    if (r.errorHandler != null) {
      return emmitError(r);
    }
    log.error(_here, 'connection timeout ${r.url} cause $e', s);
    return giveup(
        ctx, NetworkTimeoutEvent(exception: e, url: r.url)); //body is err id
  } catch (e, s) {
    //handle exception here to get better stack trace
    if (r.errorHandler != null) {
      return emmitError(r);
    }
    log.error(_here, 'unknown exception ${r.url} cause $e', s);
    log.sendToGlobalExceptionHanlder(ctx, e, s);
    return null;
  }
}

/// emmitError send error to onError
///
///   commandHttp.giveup(c.ERefuseInternet());
emmitError(Request r) {
  try {
    r.errorHandler();
  } catch (_) {}
}

/// giveup brodcast event then return null
///
///     commandHttp.giveup(ctx,ERefuseInternet());
giveup(BuildContext ctx, dynamic e) {
  eventbus.broadcast(ctx, e);
}

/// retry use contract, broadcast event when failed
///
///     await commandHttp.retry(ctx,c.CAccessTokenExpired(), c.ERefuseSignin(), req);
Future<List<int>> retry(BuildContext ctx,
    {eventbus.Contract contract, dynamic fail, Request request}) async {
  if (await eventbus.contract(ctx, contract)) {
    log.log('$_here~ok,retry');
    return await doPost(ctx, request);
  }
  if (fail != null) {
    eventbus.broadcast(ctx, fail);
  }
  return null;
}
