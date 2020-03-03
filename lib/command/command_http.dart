import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/tools/tools.dart' as tools;
import 'package:libcli/event_bus/event_bus.dart' as eventBus;
import 'package:libcli/events/events.dart';
import 'cookies.dart';

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
  req.isInternetConnected = tools.isInternetConnected;
  req.isGoogleCloudFunctionAvailable = tools.isGoogleCloudFunctionAvailable;
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

  var cookies = await loadCookies();
  if (cookies != '') {
    log.debug(_here, 'cookies=$cookies');
    headers['Cookie'] = cookies;
  }

  try {
    var resp = await r.client
        .post(r.url, headers: headers, body: r.bytes)
        .timeout(Duration(milliseconds: r.timeout));

    cookies = resp.headers['set-cookie'];
    if (cookies != null) {
      log.debug(_here, 'set-cookies=$cookies');
      saveCookies(cookies);
    }

    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    }

    if (r.onError != null) {
      return emmitError(r);
    }

    var msg = 'got ${resp.statusCode} ${resp.body} from ${r.url}';
    log.debugWarning(_here, msg);
    switch (resp.statusCode) {
      case 500: //internal server error
        return giveup(EError(resp.body)); //body is err id
      case 501: //the remote servie is not properly setup
        return throw Exception(msg); //remote server not setup so no error id
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
    throw Exception('unsupport status ' + msg);
  } on TimeoutException catch (e, s) {
    if (r.onError != null) {
      return emmitError(r);
    }
    var errID = log.error(_here, e, s);
    return giveup(EClientTimeout(errID));
  } on SocketException catch (e, s) {
    if (r.onError != null) {
      return emmitError(r);
    }
    if (await r.isInternetConnected()) {
      if (await r.isGoogleCloudFunctionAvailable()) {
        log.debugAlert(_here, 'caught service not available');
        return giveup(EContactUs(e, s));
      } else {
        log.debugAlert(_here, 'caught service blocked');
        return giveup(EServiceBlocked());
      }
    } else {
      log.debugWarning(_here, 'caught no network');
      return await retry(CInternetRequired(), ERefuseInternet(), r);
    }
  } catch (e, s) {
    if (r.onError != null) {
      return emmitError(r);
    }
    //handle exception here to get better stack trace
    var errId = log.error(_here, e, s);
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
    log.debug(_here, 'ok, redo post');
    return await doPost(r);
  }
  eventBus.brodcast(fail);
  return null;
}
