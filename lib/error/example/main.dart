import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/log.dart' as log;
import 'package:libcli/command.dart' as command;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/app/app.dart' as app;
import '../error.dart';

main() => app.start(
      appName: 'error example',
      routes: (_) => const ErrorExample(),
    );

class ErrorExample extends StatelessWidget {
  const ErrorExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Wrap(
            children: [
              ElevatedButton(
                  child: const Text('throw exception'),
                  onPressed: () {
                    watch(() => throw Exception('mock exception'));
                  }),
              ElevatedButton(
                  child: const Text('throw exception twice'),
                  onPressed: () {
                    watch(() {
                      Future.delayed(const Duration(seconds: 3), () {
                        throw Exception('second exception');
                      });
                      throw Exception('first exception');
                    });
                  }),
              ElevatedButton(
                  child: const Text('firewall block'),
                  onPressed: () {
                    watch(() {});
                    eventbus.broadcast(context, command.FirewallBlockEvent('BLOCK_SHORT'));
                  }),
              ElevatedButton(
                  child: const Text('no internet'),
                  onPressed: () async {
                    watch(() {});
                    try {
                      throw const SocketException('wifi off');
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
                  child: const Text('service not available'),
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
                  child: const Text('internet blocked'),
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
                  child: const Text('internal server error'),
                  onPressed: () {
                    eventbus.broadcast(context, command.InternalServerErrorEvent());
                  }),
              ElevatedButton(
                  child: const Text('server not ready'),
                  onPressed: () {
                    eventbus.broadcast(context, command.ServerNotReadyEvent());
                  }),
              ElevatedButton(
                  child: const Text('bad request'),
                  onPressed: () {
                    eventbus.broadcast(context, command.BadRequestEvent());
                  }),
              ElevatedButton(
                  child: const Text('client timeout'),
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
                  child: const Text('deadline exceeded'),
                  onPressed: () async {
                    var ok = await eventbus.broadcast(
                        context, command.RequestTimeoutContract(isServer: true, url: 'http://mock'));
                    dialog.info(context, text: ok ? 'retry' : 'cancel');
                  }),
              ElevatedButton(
                  child: const Text('slow network'),
                  onPressed: () {
                    eventbus.broadcast(context, command.SlowNetworkEvent());
                  }),
              ElevatedButton(
                  child: const Text('disk error'),
                  onPressed: () {
                    throw log.DiskErrorException();
                  }),
            ],
          ),
        ],
      )),
    );
  }
}
