import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/log.dart' as log;
import 'package:libcli/command.dart' as command;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/dialog.dart' as dialog;
import 'error.dart';

class ErrorPlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Wrap(
          children: [
            ElevatedButton(
                child: Text('throw exception'),
                onPressed: () {
                  watch(() => throw Exception('mock exception'));
                }),
            ElevatedButton(
                child: Text('throw exception twice'),
                onPressed: () {
                  watch(() {
                    Future.delayed(Duration(seconds: 3), () {
                      throw Exception('second exception');
                    });
                    throw Exception('first exception');
                  });
                }),
            ElevatedButton(
                child: Text('firewall block'),
                onPressed: () {
                  watch(() {});
                  eventbus.broadcast(context, command.FirewallBlockEvent());
                }),
            ElevatedButton(
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
                    dialog.info(context, text: ok ? 'retry' : 'cancel');
                  }
                }),
            ElevatedButton(
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
            ElevatedButton(
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
            ElevatedButton(
                child: Text('internal server error'),
                onPressed: () {
                  eventbus.broadcast(context, command.InternalServerErrorEvent());
                }),
            ElevatedButton(
                child: Text('server not ready'),
                onPressed: () {
                  eventbus.broadcast(context, command.ServerNotReadyEvent());
                }),
            ElevatedButton(
                child: Text('bad request'),
                onPressed: () {
                  eventbus.broadcast(context, command.BadRequestEvent());
                }),
            ElevatedButton(
                child: Text('client timeout'),
                onPressed: () async {
                  try {
                    throw TimeoutException('client timeout');
                  } catch (e) {
                    var ok = await eventbus.broadcast(
                        context, command.RequestTimeoutContract(isServer: false, exception: e, url: 'http://mock'));
                    dialog.info(context, text: ok ? 'retry' : 'cancel');
                  }
                }),
            ElevatedButton(
                child: Text('deadline exceeded'),
                onPressed: () async {
                  var ok = await eventbus.broadcast(
                      context, command.RequestTimeoutContract(isServer: true, url: 'http://mock'));
                  dialog.info(context, text: ok ? 'retry' : 'cancel');
                }),
            ElevatedButton(
                child: Text('slow network'),
                onPressed: () {
                  eventbus.broadcast(context, command.SlowNetworkEvent());
                }),
            ElevatedButton(
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
