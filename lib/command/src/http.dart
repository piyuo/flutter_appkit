import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/command/src/events.dart';
import 'package:libcli/command/src/http_header.dart';
import 'package:libcli/command/src/protobuf.dart';
import 'package:libcli/command/src/service.dart';

///Request for post()
class Request {
  final Service service;
  final http.Client client;
  final String url;
  final pb.Object action;
  Duration timeout;
  Duration slow;
  Request({
    required this.service,
    required this.client,
    required this.url,
    required this.action,
    required this.timeout,
    required this.slow,
  });
}

/// post call doPost() and broadcast network slow if request time is longer than slow
///
Future<pb.Object> post(BuildContext ctx, Request request, pb.Builder builder) async {
  Completer<pb.Object> completer = Completer<pb.Object>();
  var timer = Timer(request.slow, () {
    if (!completer.isCompleted) {
      eventbus.broadcast(ctx, SlowNetworkEvent());
    }
  });
  doPost(ctx, request, builder).then((response) {
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
Future<pb.Object> doPost(BuildContext context, Request r, pb.Builder builder) async {
  try {
    var headers = await doRequestHeaders();
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
      case 500: //internal server error
        return await giveup(context, InternalServerErrorEvent()); //body is err id
      case 501: //the remote service is not properly setup
        return await giveup(context, ServerNotReadyEvent()); //body is err id
      case 504: //service context deadline exceeded
        log.log('[http] caught 504 deadline exceeded ${r.url}, body:${resp.body}');
        return await retry(context, builder,
            contract: RequestTimeoutContract(isServer: true, errorID: resp.body, url: r.url),
            request: r); //body is err id
      case 511: //access token required
        return await retry(context, builder, contract: CAccessTokenRequired(), request: r);
      case 412: //access token expired
        return await retry(context, builder, contract: CAccessTokenExpired(), request: r);
      case 402: //payment token expired
        return await retry(context, builder, contract: CPaymentTokenRequired(), request: r);
      case 400: //bad request
        return await giveup(context, BadRequestEvent()); //body is err id
    }
    //unknown status code
    throw Exception('unknown $msg');
  } on SocketException catch (e) {
    log.log('[http] failed to connect ${r.url} cause $e');
    return await retry(context, builder, contract: InternetRequiredContract(exception: e, url: r.url), request: r);
  } on TimeoutException catch (e) {
    log.log('[http] connect timeout ${r.url} cause $e');
    return await retry(context, builder,
        contract: RequestTimeoutContract(isServer: false, exception: e, url: r.url), request: r);
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
///
///     commandHttp.giveup(ctx,BadRequestEvent());
///
Future<pb.Object> giveup(BuildContext ctx, dynamic e) async {
  eventbus.broadcast(ctx, e);
  return pb.empty;
}

/// retry use contract, return empty proto object is contract failed
///
///     await commandHttp.retry(ctx,c.CAccessTokenExpired(), c.ERefuseSignin(), req);
///
Future<pb.Object> retry(
  BuildContext context,
  pb.Builder builder, {
  required eventbus.Contract contract,
  required Request request,
}) async {
  if (await eventbus.broadcast(context, contract)) {
    log.log('[http] try again');
    return await doPost(context, request, builder);
  }
  return pb.empty;
}
