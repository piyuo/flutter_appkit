import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/log/log.dart';
import 'package:libcli/tools/net.dart' as net;
import 'package:libcli/event_bus/event_bus.dart' as eventBus;
import 'package:libcli/constant/events.dart';
import 'package:libcli/constant/contracts.dart';
import 'package:libcli/data/cookies.dart' as cookies;

const _here = 'command_http';

///Request for reuest(),let test more easily
class Request {
  http.Client client;
  String url;
  Uint8List bytes;
  int timeout;
  Future<bool> Function() isInternetConnected;
  Future<bool> Function() isGoogleCloudFunctionAvailable;
  Function onError;
}

/// post call request() and broadcast network slow if request time is longer than slow
///
///     await commandHttp.postclient, '', bytes, 500, 1);
///     expect(listener.latestEvent is contract.EventNetworkSlow, true);
Future<List<int>> post(http.Client client, String url, Uint8List bytes,
    int timeout, int slow, Function onError) async {
  Completer<List<int>> completer = new Completer<List<int>>();
  var timer = Timer(Duration(milliseconds: slow), () {
    if (!completer.isCompleted) {
      eventBus.brodcast(ENetworkSlow());
    }
  });
  Request req = Request();
  req.client = client;
  req.url = url;
  req.bytes = bytes;
  req.timeout = timeout;
  req.isInternetConnected = net.isInternetConnected;
  req.isGoogleCloudFunctionAvailable = net.isGoogleCloudFunctionAvailable;
  req.onError = onError;
  doPost(req).then((response) {
    timer.cancel();
    completer.complete(response);
  });
  /* no need to catch error since request() catch all exception
  .catchError((e) {
    timer.cancel();
    completer.completeError(e);
  });
  */
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
Future<List<int>> doPost(Request r) async {
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'accept': '',
  };

  if (kReleaseMode && !kIsWeb) {
    var c = await cookies.get();
    if (c.length > 0) {
      '$_here|cookies=$c'.print;
      headers['Cookie'] = c;
    }
  }

  try {
    var resp = await r.client
        .post(r.url, headers: headers, body: r.bytes)
        .timeout(Duration(milliseconds: r.timeout));

    if (kReleaseMode && !kIsWeb) {
      var c = resp.headers['set-cookie'];
      if (c != null && c.length > 0) {
        '$_here|set-cookies=$c'.print;
        cookies.set(c);
      }
    }

    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    }

    if (r.onError != null) {
      return emmitError(r);
    }
    var msg = '${resp.statusCode} ${resp.body} from ${r.url}';
    '$_here|caught $msg'.log;
    switch (resp.statusCode) {
      case 500: //internal server error
        return giveup(EError(resp.body)); //body is err id
      case 501: //the remote servie is not properly setup
        return throw Exception(); //remote server not setup so no error id, treat as unknow error
      case 504: //service context deadline exceeded
        return giveup(EServiceTimeout(resp.body)); //body is err id
      case 511: //access token required
        return await retry(CAccessTokenRequired(), ERefuseSignin(), r);
      case 412: //access token expired
        return await retry(CAccessTokenExpired(), ERefuseSignin(), r);
      case 402: //payment token expired
        return await retry(CPaymentTokenRequired(), ERefuseSignin(), r);
    }
    //unknow status code
    throw Exception('unknown status ' + msg);
  } on TimeoutException catch (e, s) {
    if (r.onError != null) {
      return emmitError(r);
    }
    var errID = _here.error(e, s);
    return giveup(EClientTimeout(errID));
  } on SocketException catch (e, s) {
    if (r.onError != null) {
      return emmitError(r);
    }
    if (await r.isInternetConnected()) {
      if (await r.isGoogleCloudFunctionAvailable()) {
        '$_here|service not available'.alert;
        return giveup(EContactUs(e, s));
      } else {
        '$_here|service blocked'.alert;
        return giveup(EServiceBlocked());
      }
    } else {
      '$_here|no network'.warning;
      return await retry(CInternetRequired(), ERefuseInternet(), r);
    }
  } catch (e, s) {
    if (r.onError != null) {
      return emmitError(r);
    }
    //handle exception here to get better stack trace
    var errId = _here.error(e, s);
    return giveup(EError(errId));
  }
}

/// emmitError send error to onError
///
///   commandHttp.giveup(c.ERefuseInternet());
emmitError(Request r) {
  try {
    r.onError();
  } catch (_) {}
  return null;
}

/// giveup brodcast event then return null
///
///   commandHttp.giveup(c.ERefuseInternet());
giveup(dynamic e) {
  eventBus.brodcast(e);
  return null;
}

/// retry use contract, broadcast event when failed
///
///     await commandHttp.retry(c.CAccessTokenExpired(), c.ERefuseSignin(), req);
Future<List<int>> retry(
    eventBus.Contract contr, dynamic fail, Request r) async {
  if (await eventBus.contract(contr)) {
    '$_here|ok,retry'.log;
    return await doPost(r);
  }
  eventBus.brodcast(fail);
  return null;
}
