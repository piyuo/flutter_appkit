import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/src/log/log.dart';
import 'package:libcli/src/command/command.dart';
import 'package:libcli/src/eventbus/eventbus.dart';
import 'package:libcli/dialogs.dart';
import 'package:libcli/src/errors/main.dart';

class ErrorsPlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Wrap(
          children: [
            FlatButton(
                child: Text('throw exception'),
                onPressed: () {
                  watch(() => throw Exception('mock exception'));
                }),
            FlatButton(
                child: Text('guard denied'),
                onPressed: () {
                  watch(() {});
                  broadcast(context, GuardDeniedEvent());
                }),
            FlatButton(
                child: Text('no internet'),
                onPressed: () async {
                  watch(() {});
                  try {
                    throw SocketException('wifi off');
                  } catch (e) {
                    var contract = InternetRequiredContract(exception: e, url: 'http://mock');
                    contract.isInternetConnected = () async {
                      return false;
                    };
                    var ok = await broadcast(context, contract);
                    toast(context, ok ? 'retry' : 'cancel');
                  }
                }),
            FlatButton(
                child: Text('service not available'),
                onPressed: () async {
                  watch(() {});
                  var contract = InternetRequiredContract(url: 'http://mock');
                  contract.isInternetConnected = () async {
                    return true;
                  };
                  contract.isGoogleCloudFunctionAvailable = () async {
                    return true;
                  };
                  await broadcast(context, contract);
                }),
            FlatButton(
                child: Text('internet blocked'),
                onPressed: () async {
                  watch(() {});
                  var contract = InternetRequiredContract(url: 'http://mock');
                  contract.isInternetConnected = () async {
                    return true;
                  };
                  contract.isGoogleCloudFunctionAvailable = () async {
                    return false;
                  };
                  await broadcast(context, contract);
                }),
            FlatButton(
                child: Text('internal server error'),
                onPressed: () {
                  broadcast(context, InternalServerErrorEvent());
                }),
            FlatButton(
                child: Text('server not ready'),
                onPressed: () {
                  broadcast(context, ServerNotReadyEvent());
                }),
            FlatButton(
                child: Text('bad request'),
                onPressed: () {
                  broadcast(context, BadRequestEvent());
                }),
            FlatButton(
                child: Text('client timeout'),
                onPressed: () async {
                  try {
                    throw TimeoutException('client timeout');
                  } catch (e) {
                    var ok = await broadcast(
                        context, RequestTimeoutContract(isServer: false, exception: e, url: 'http://mock'));
                    toast(context, ok ? 'retry' : 'cancel');
                  }
                }),
            FlatButton(
                child: Text('deadline exceeded'),
                onPressed: () async {
                  var ok = await broadcast(context, RequestTimeoutContract(isServer: true, url: 'http://mock'));
                  toast(context, ok ? 'retry' : 'cancel');
                }),
            FlatButton(
                child: Text('slow network'),
                onPressed: () {
                  broadcast(context, SlowNetworkEvent());
                }),
            FlatButton(
                child: Text('disk error'),
                onPressed: () {
                  throw DiskErrorException();
                }),
          ],
        ),
      ],
    ));
  }
}
