import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:libcli/log.dart';
import 'package:libcli/command.dart';
import 'package:libcli/eventbus.dart';
import 'package:libcli/dialogs.dart';
import 'package:libcli/src/errors/errors.dart';
import 'package:provider/provider.dart';

class ErrorsPlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      children: [
        Wrap(
          children: [
            CupertinoButton(
                child: Text('throw exception'),
                onPressed: () {
                  watch(() => throw Exception('mock exception'));
                }),
            CupertinoButton(
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
                    Dialogs.of(context).toast(context, ok ? 'retry' : 'cancel');
                  }
                }),
            CupertinoButton(
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
                  var ok = await broadcast(context, contract);
                  Dialogs.of(context).toast(context, ok ? 'retry' : 'cancel');
                }),
            CupertinoButton(
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
                  var ok = await broadcast(context, contract);
                  Dialogs.of(context).toast(context, ok ? 'retry' : 'cancel');
                }),
            CupertinoButton(
                child: Text('internal server error'),
                onPressed: () {
                  broadcast(context, InternalServerErrorEvent());
                }),
            CupertinoButton(
                child: Text('server not ready'),
                onPressed: () {
                  broadcast(context, ServerNotReadyEvent());
                }),
            CupertinoButton(
                child: Text('bad request'),
                onPressed: () {
                  broadcast(context, BadRequestEvent());
                }),
            CupertinoButton(
                child: Text('client timeout'),
                onPressed: () async {
                  try {
                    throw TimeoutException('client timeout');
                  } catch (e) {
                    var ok = await broadcast(
                        context, RequestTimeoutContract(isServer: false, exception: e, url: 'http://mock'));
                    Dialogs.of(context).toast(context, ok ? 'retry' : 'cancel');
                  }
                }),
            CupertinoButton(
                child: Text('deadline exceeded'),
                onPressed: () async {
                  var ok = await broadcast(context, RequestTimeoutContract(isServer: true, url: 'http://mock'));
                  Dialogs.of(context).toast(context, ok ? 'retry' : 'cancel');
                }),
            CupertinoButton(
                child: Text('slow network'),
                onPressed: () {
                  broadcast(context, SlowNetworkEvent());
                }),
            CupertinoButton(
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
