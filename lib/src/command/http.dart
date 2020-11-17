import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/log.dart';
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/src/command/events.dart';
import 'package:libcli/src/command/http-header.dart';
import 'package:libcli/src/command/protobuf.dart';
import 'package:libcli/src/command/service.dart';
import 'package:libpb/pb.dart' as pb;

///Request for reuest(),let test more easily
class Request {
  Service service;
  http.Client client;
  String url;
  Uint8List bytes;
  int timeout;
  Future<bool> Function()? isInternetConnected;
  Future<bool> Function()? isGoogleCloudFunctionAvailable;
  Request({
    required this.service,
    required this.client,
    required this.url,
    required this.bytes,
    required this.timeout,
    this.isInternetConnected,
    this.isGoogleCloudFunctionAvailable,
  });
}

/// post call doPost() and broadcast network slow if request time is longer than slow
///
Future<pb.ProtoObject> post(
  BuildContext ctx,
  Service service,
  http.Client client,
  String url,
  pb.ProtoObject obj,
  int timeout,
  int slow,
) async {
  Completer<pb.ProtoObject> completer = new Completer<pb.ProtoObject>();
  var timer = Timer(Duration(milliseconds: slow), () {
    if (!completer.isCompleted) {
      eventbus.broadcast(ctx, SlowNetworkEvent());
    }
  });
  Uint8List bytes = encode(obj);
  Request req = Request(
    service: service,
    client: client,
    url: url,
    bytes: bytes,
    timeout: timeout,
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
Future<pb.ProtoObject> doPost(BuildContext context, Request r) async {
  try {
    var headers = await doRequestHeaders();
    var resp = await r.client.post(r.url, headers: headers, body: r.bytes).timeout(Duration(milliseconds: r.timeout));
    await doResponseHeaders(resp.headers);

    if (resp.statusCode == 200) {
      return decode(resp.bodyBytes, r.service);
    }

    var msg = '${resp.statusCode} ${resp.body} from ${r.url}';
    log('${COLOR_WARNING}caught $msg');
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
          request: r,
        );
      case 412: //access token expired
        return await retry(
          context,
          contract: CAccessTokenExpired(),
          request: r,
        );
      case 402: //payment token expired
        return await retry(
          context,
          contract: CPaymentTokenRequired(),
          request: r,
        );
      case 400: //bad request
        return giveup(context, BadRequestEvent()); //body is err id
    }
    //unknow status code
    throw Exception('unknown status ' + msg);
  } on SocketException catch (e) {
    log('${COLOR_WARNING}failed to connect ${r.url} cause $e');
    return await retry(context, contract: InternetRequiredContract(exception: e, url: r.url), request: r);
  } on TimeoutException catch (e) {
    log('${COLOR_WARNING}connection timeout ${r.url} cause $e');
    return await retry(context,
        contract: RequestTimeoutContract(isServer: false, exception: e, url: r.url), request: r);
  }

  //throw everything else
  //catch (e, s) {
  //handle exception here to get better stack trace
  //log.error( '$e, url: ${r.url}', s);
  //log.sendToGlobalExceptionHanlder(context, e, s);
  //return null;
  //}
}

/// giveup brodcast event then return null
///
///     commandHttp.giveup(ctx,BadRequestEvent());
///
giveup(BuildContext ctx, dynamic e) {
  eventbus.broadcast(ctx, e);
}

/// retry use contract, return empty proto object is contract failed
///
///     await commandHttp.retry(ctx,c.CAccessTokenExpired(), c.ERefuseSignin(), req);
///
Future<pb.ProtoObject> retry(
  BuildContext context, {
  required eventbus.Contract contract,
  required Request request,
}) async {
  if (await eventbus.contract(context, contract)) {
    log('try again');
    return await doPost(context, request);
  }
  return pb.ProtoObject.empty;
}
