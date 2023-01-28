import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/command/src/events.dart';
import 'package:libcli/command/src/protobuf.dart';
import 'package:libcli/command/src/service.dart';

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
  final Service service;

  /// client for post request
  final http.Client client;

  /// url for post request
  final String url;

  /// action for post request
  final pb.Object action;

  /// timeout for post request
  Duration timeout;

  /// slow for post request
  Duration slow;

  /// isRetry is true if this request is in retry
  bool isRetry = false;
}

Future<Map<String, String>> doRequestHeaders(String acceptLanguage) async {
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'Accept-Language': acceptLanguage,
    //'accept': '',
  };
  return headers;
}

Future<void> doResponseHeaders(Map<String, String> headers) async {
  /*var c = headers['set-cookie'];
  if (c != null && c.isNotEmpty) {
  }*/
}

/// post call doPost() and broadcast network slow if request time is longer than slow
Future<pb.Object> post(Request request, pb.Builder? builder) async {
  Completer<pb.Object> completer = Completer<pb.Object>();
  var timer = Timer(request.slow, () {
    if (!completer.isCompleted) {
      eventbus.broadcast(SlowNetworkEvent());
    }
  });
  doPost(request, builder).then((response) {
    timer.cancel();
    completer.complete(response);
  });
  // no need to catch error since doPost() catch all exception
  return completer.future;
}

/// doPost  send action bytes to remote url and return response bytes, this function will use contract to fix error
/// ```dart
/// var req = commandHttp.Request();
/// req.client = client;
/// req.bytes = Uint8List(2);
/// req.url = 'http://mock';
/// req.timeout = 9000;
/// var bytes = await commandHttp.doPost(req);
/// ```
Future<pb.Object> doPost(Request r, pb.Builder? builder) async {
  try {
    // auto add access token
    String? accessToken;
    if (r.action.accessTokenRequired) {
      accessToken = await r.service.accessTokenBuilder!();
      if (accessToken == null) {
        return await giveup(NoAccessTokenEvent());
      }
      r.action.setAccessToken(accessToken);
    }
    var headers = await doRequestHeaders(r.service.acceptLanguage!());
    Uint8List bytes = encode(r.action);
    var uri = Uri.parse(r.url);
    var resp = await r.client.post(uri, headers: headers, body: bytes).timeout(r.timeout);
    await doResponseHeaders(resp.headers);

    if (resp.statusCode == 200) {
      return decode(resp.bodyBytes, r.service, builder);
    }

    var msg = '${resp.statusCode} ${resp.body} from ${r.url}';
    log.log('[http] caught $msg');
    switch (resp.statusCode) {
      case 500: // internal server error
        return await giveup(InternalServerErrorEvent()); //body is err id
      case 501: // the remote service is not properly setup
        return await giveup(ServerNotReadyEvent()); //body is err id
      case 504: // service context deadline exceeded
        log.log('[http] caught 504 deadline exceeded ${r.url}, body:${resp.body}');
        return await retry(
            builder, RequestTimeoutContract(isServer: true, errorID: resp.body, url: r.url), r); //body is err id
      // todo: handle 511 on remote
      case 511: // force logout
        return await retry(builder, ForceLogOutEvent(), r);
      case 412: // access token expired
      case 402: // payment token expired
        return await retry(builder, AccessTokenRevokedEvent(accessToken), r);
      case 400: // bad request
        return await giveup(BadRequestEvent()); //body is err id
    }
    //unknown status code
    throw Exception('unknown $msg');
  } on SocketException catch (e) {
    log.log('[http] failed to connect ${r.url} cause $e');
    return await retry(builder, InternetRequiredContract(exception: e, url: r.url), r);
  } on TimeoutException catch (e) {
    log.log('[http] connect timeout ${r.url} cause $e');
    return await retry(builder, RequestTimeoutContract(isServer: false, exception: e, url: r.url), r);
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
Future<pb.Object> giveup(dynamic e) async {
  eventbus.broadcast(e);
  return pb.empty;
}

/// retry use contract, return empty proto object is contract failed
/// ```dart
/// await commandHttp.retry(ctx,c.CAccessTokenExpired(), c.ERefuseSignin(), req);
/// ```
Future<pb.Object> retry(pb.Builder? builder, dynamic event, Request request) async {
  if (request.isRetry) {
    // if already in retry, giveup
    return await giveup(TooManyRetryEvent());
  }
  request.isRetry = true;
  await eventbus.broadcast(event);
  log.log('[http] try again');
  return await doPost(request, builder);
}
