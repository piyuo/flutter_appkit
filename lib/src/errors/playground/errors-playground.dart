import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/src/log/log.dart' as log;
import 'package:libcli/src/command/command.dart' as command;
import 'package:libcli/src/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/src/dialogs/dialogs.dart' as dialogs;
import 'package:libcli/src/errors/main.dart';

class ErrorsPlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Wrap(
          children: [
            TextButton(
                child: Text('throw exception'),
                onPressed: () {
                  watch(() => throw Exception('mock exception'));
                }),
            TextButton(
                child: Text('guard denied'),
                onPressed: () {
                  watch(() {});
                  eventbus.broadcast(context, command.GuardDeniedEvent());
                }),
            TextButton(
                child: Text('no internet'),
                onPressed: () async {
                  watch(() {});
                  try {
                    throw SocketException('wifi off');
                  } catch (e) {
                    var contract = command.InternetRequiredContract(exception: e, url: 'http://mock');
                    contract.isInternetConnected = () async {
                      return false;
                    };
                    var ok = await eventbus.broadcast(context, contract);
                    dialogs.toast(context, ok ? 'retry' : 'cancel');
                  }
                }),
            TextButton(
                child: Text('service not available'),
                onPressed: () async {
                  watch(() {});
                  var contract = command.InternetRequiredContract(url: 'http://mock');
                  contract.isInternetConnected = () async {
                    return true;
                  };
                  contract.isGoogleCloudFunctionAvailable = () async {
                    return true;
                  };
                  await eventbus.broadcast(context, contract);
                }),
            TextButton(
                child: Text('internet blocked'),
                onPressed: () async {
                  watch(() {});
                  var contract = command.InternetRequiredContract(url: 'http://mock');
                  contract.isInternetConnected = () async {
                    return true;
                  };
                  contract.isGoogleCloudFunctionAvailable = () async {
                    return false;
                  };
                  await eventbus.broadcast(context, contract);
                }),
            TextButton(
                child: Text('internal server error'),
                onPressed: () {
                  eventbus.broadcast(context, command.InternalServerErrorEvent());
                }),
            TextButton(
                child: Text('server not ready'),
                onPressed: () {
                  eventbus.broadcast(context, command.ServerNotReadyEvent());
                }),
            TextButton(
                child: Text('bad request'),
                onPressed: () {
                  eventbus.broadcast(context, command.BadRequestEvent());
                }),
            TextButton(
                child: Text('client timeout'),
                onPressed: () async {
                  try {
                    throw TimeoutException('client timeout');
                  } catch (e) {
                    var ok = await eventbus.broadcast(
                        context, command.RequestTimeoutContract(isServer: false, exception: e, url: 'http://mock'));
                    dialogs.toast(context, ok ? 'retry' : 'cancel');
                  }
                }),
            TextButton(
                child: Text('deadline exceeded'),
                onPressed: () async {
                  var ok = await eventbus.broadcast(
                      context, command.RequestTimeoutContract(isServer: true, url: 'http://mock'));
                  dialogs.toast(context, ok ? 'retry' : 'cancel');
                }),
            TextButton(
                child: Text('slow network'),
                onPressed: () {
                  eventbus.broadcast(context, command.SlowNetworkEvent());
                }),
            TextButton(
                child: Text('disk error'),
                onPressed: () {
                  throw log.DiskErrorException();
                }),
          ],
        ),
      ],
    ));
  }
}
