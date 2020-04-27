import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/log.dart' as log;
import 'package:libcli/command.dart' as command;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/client.dart' as client;
import 'package:libcli/src/client/playground/wrong_provider_page.dart';

class ClientPlaygroundProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {}
}

class ClientPlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Wrap(
              children: [
                RaisedButton(
                    child: Text('wrong provider page'),
                    onPressed: () {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(builder: (_) {
                        return WrongProviderPage();
                      }));
                    }),
                RaisedButton(
                    child: Text('throw exception'),
                    onPressed: () {
                      try {
                        throw 'mock exception';
                      } catch (e, s) {
                        log.sendToGlobalExceptionHanlder(context, e, s);
                      }
                    }),
                RaisedButton(
                    child: Text('no internet'),
                    onPressed: () {
                      try {
                        throw SocketException('wifi off');
                      } catch (e) {
                        var contract = command.InternetRequiredContract(
                            exception: e, url: 'http://mock');
                        contract.isInternetConnected = () async {
                          return false;
                        };
                        client.internetRequired(context, contract);
                      }
                    }),
                RaisedButton(
                    child: Text('service not available'),
                    onPressed: () {
                      var contract =
                          command.InternetRequiredContract(url: 'http://mock');
                      contract.isInternetConnected = () async {
                        return true;
                      };
                      contract.isGoogleCloudFunctionAvailable = () async {
                        return true;
                      };
                      client.internetRequired(context, contract);
                    }),
                RaisedButton(
                    child: Text('internet blocked'),
                    onPressed: () {
                      var contract =
                          command.InternetRequiredContract(url: 'http://mock');
                      contract.isInternetConnected = () async {
                        return true;
                      };
                      contract.isGoogleCloudFunctionAvailable = () async {
                        return false;
                      };
                      client.internetRequired(context, contract);
                    }),
                RaisedButton(
                    child: Text('internal server error'),
                    onPressed: () {
                      eventbus.broadcast(
                          context, command.InternalServerErrorEvent());
                    }),
                RaisedButton(
                    child: Text('server not ready'),
                    onPressed: () {
                      eventbus.broadcast(
                          context, command.ServerNotReadyEvent());
                    }),
                RaisedButton(
                    child: Text('bad request'),
                    onPressed: () {
                      eventbus.broadcast(context, command.BadRequestEvent());
                    }),
                RaisedButton(
                    child: Text('client timeout'),
                    onPressed: () {
                      try {
                        throw TimeoutException('client timeout');
                      } catch (e) {
                        eventbus.broadcast(
                            context,
                            command.RequestTimeoutContract(
                                isServer: false,
                                exception: e,
                                url: 'http://mock'));
                      }
                    }),
                RaisedButton(
                    child: Text('deadline exceeded'),
                    onPressed: () {
                      eventbus.broadcast(
                          context,
                          command.RequestTimeoutContract(
                              isServer: true, url: 'http://mock'));
                    }),
                RaisedButton(
                    child: Text('slow network'),
                    onPressed: () {
                      eventbus.broadcast(context, command.SlowNetworkEvent());
                    }),
                RaisedButton(
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
