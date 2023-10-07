import 'dart:async';
import 'dart:typed_data';
import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/net/net.dart' as net;

/// Request for post()
class Request {
  Request({
    required this.service,
    required this.client,
    required this.url,
    required this.action,
    required this.timeout,
    required this.slow,
  });

  /// service that fire this request
  final net.Service service;

  /// client for post request
  final http.Client client;

  /// url for post request
  final String url;

  /// action for post request
  final net.Object action;

  /// timeout for post request
  Duration timeout;

  /// slow for post request
  Duration slow;

  /// isRetry is true if this request is in retry
  bool isRetry = false;
}

/// _requestHeaders return request headers
Map<String, String> get _requestHeaders => {
      'Content-Type': 'multipart/form-data',
      'Accept-Language': i18n.acceptLanguage,
    };

/// post call doPost() and broadcast network slow if request time is longer than slow
Future<net.Object> post(Request request, net.Builder? builder) async {
  Completer<net.Object> completer = Completer<net.Object>();
  var timer = Timer(request.slow, () {
    if (!completer.isCompleted) {
      eventbus.broadcast(net.SlowNetworkEvent());
    }
  });
  doPost(request, builder).then((response) {
    timer.cancel();
    completer.complete(response);
  });
  // no need to catch error since doPost() catch all exception
  return completer.future;
}

/// [doPost] send action bytes to remote url and return response bytes, this function will use contract to fix error
/// ```dart
/// var req = Request();
/// req.client = client;
/// req.bytes = Uint8List(2);
/// req.url = 'http://mock';
/// req.timeout = 9000;
/// var bytes = await doPost(req);
/// ```
Future<net.Object?> doPost(Request r, net.Builder? builder) async {
  try {
    // auto add access token
    String? accessToken;
    if (r.action.accessTokenRequired) {
      accessToken = await r.service.accessTokenBuilder!();
      if (accessToken == null) {
        return await giveup(net.NeedLoginEvent());
      }
      r.action.setAccessToken(accessToken);
    }
    Uint8List bytes = net.encode(r.action);
    var uri = Uri.parse(r.url);
    var resp = await r.client
        .post(
          uri,
          headers: _requestHeaders,
          body: bytes,
        )
        .timeout(r.timeout);

    if (resp.statusCode == 200) {
      return net.decode(resp.bodyBytes, builder);
    }

    var msg = '${resp.statusCode} ${resp.body} from ${r.url}';
    log.log('[http] caught $msg');
    switch (resp.statusCode) {
      case 500: // internal server error
        return await giveup(net.InternalServerErrorEvent()); //body is err id
      case 501: // the remote service is not properly setup
        return await giveup(net.ServerNotReadyEvent()); //body is err id
      case 504: // service context deadline exceeded
        log.log('[http] caught 504 deadline exceeded ${r.url}, body:${resp.body}');
        return await giveup(net.RequestTimeoutEvent(isServer: true, errorID: resp.body, url: r.url)); //body is err id
      // todo: handle 511 on remote
      case 511: // force logout
        return await giveup(net.ForceLogOutEvent());
      case 412: // access token expired
      case 402: // payment token expired
        return await retry(builder, net.AccessTokenRevokedEvent(accessToken), r);
      case 400: // bad request
        return await giveup(net.BadRequestEvent()); //body is err id
    }
    //unknown status code
    throw Exception('unknown $msg');
  } on SocketException catch (e) {
    log.log('[http] failed to connect ${r.url} cause $e');
    return await giveup(net.InternetRequiredEvent(exception: e, url: r.url));
  } on TimeoutException catch (e) {
    log.log('[http] connect timeout ${r.url} cause $e');
    return await giveup(net.RequestTimeoutEvent(isServer: false, exception: e, url: r.url));
  }
  //throw everything else
  //catch (e, s) {
  //handle exception here to get better stack trace
  //log.error( '$e, url: ${r.url}', s);
  //log.sendToGlobalExceptionHandler(context, e, s);
  //return null;
  //}
}

/// giveup broadcast event then return null
/// ```dart
/// commandHttp.giveup(ctx,BadRequestEvent());
/// ```
Future<net.Object?> giveup(dynamic e) async {
  eventbus.broadcast(e);
  return null;
}

/// retry use contract, return empty proto object is contract failed
/// ```dart
/// await commandHttp.retry(ctx,c.CAccessTokenExpired(), c.ERefuseSignin(), req);
/// ```
Future<net.Object?> retry(net.Builder? builder, dynamic event, Request request) async {
  if (request.isRetry) {
    // if already in retry, giveup
    return await giveup(net.TooManyRetryEvent());
  }
  request.isRetry = true;
  await eventbus.broadcast(event);
  log.log('[http] try again');
  return await doPost(request, builder);
}
