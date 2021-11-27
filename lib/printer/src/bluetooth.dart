import 'dart:async';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/i18n/i18n.dart' as i18n;

class Bluetooth {
  /// _managerLock avoid concurrent use print manager
  final _managerLock = Lock();

  /// _printerManager is the instance of [EscPosBluetoothManager]
  final _printerManager = PrinterBluetoothManager();

  /// listenDevices listen devices scanned result
  Future<StreamSubscription<List<PrinterBluetooth>>> listenDevices(
      void Function(List<PrinterBluetooth> event) onData) async {
    late StreamSubscription<List<PrinterBluetooth>> subscription;
    await _managerLock.synchronized(() async {
      subscription = _printerManager.scanResults.listen(
        onData,
        onError: (e, s) {
          log.error(e, s);
        },
      );
    });
    return subscription;
  }

  /// startScanDevices start scan bluetooth devices
  Future<void> startScanDevices() async {
    await _managerLock.synchronized(() async {
      _printerManager.startScan(const Duration(seconds: 5));
    });
  }

  /// stopScanDevices stop scan bluetooth devices
  Future<void> stopScanDevices() async {
    await _managerLock.synchronized(() async {
      _printerManager.stopScan();
    });
  }

  /// print ticket use printer, return error message if failed to print
  Future<String> print(BuildContext context, PrinterBluetooth printer, List<int> ticket) async {
    late PosPrintResult result;
    await _managerLock.synchronized(() async {
      _printerManager.selectPrinter(printer);
      result = await _printerManager.printTicket(ticket);
    });

    if (result.value == PosPrintResult.success.value) {
      return '';
    } else if (result.value == PosPrintResult.timeout.value) {
      return context.i18n.errorTimeout;
    } else if (result.value == PosPrintResult.printerNotSelected.value) {
      return context.i18n.errorPrinterNotSelected;
    } else if (result.value == PosPrintResult.ticketEmpty.value) {
      return context.i18n.errorEmptyTicket;
    } else if (result.value == PosPrintResult.printInProgress.value) {
      return context.i18n.errorAnotherPrinting;
    } else if (result.value == PosPrintResult.scanInProgress.value) {
      return context.i18n.errorScanInProgress;
    } else {
      return context.i18n.errorUnknown;
    }
  }
}
