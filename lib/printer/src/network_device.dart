import 'dart:io';
import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

/// NetworkPrinter print ticket on network printer
class NetworkDevice {
  NetworkDevice(
    this.host, {
    this.port = 9100,
    this.timeout = const Duration(seconds: 5),
  });

  final String host;

  final int port;

  final Duration timeout;

  Future<String> print(BuildContext context, List<int> ticketBytes) async {
    Socket? socket;
    try {
      socket = await Socket.connect(host, port, timeout: timeout);
      socket.add(ticketBytes);
      return '';
    } catch (e) {
      if (e is SocketException) {
        return context.i18n.errorConnect;
      }
      return e.toString();
    } finally {
      socket?.destroy();
    }
  }
}
