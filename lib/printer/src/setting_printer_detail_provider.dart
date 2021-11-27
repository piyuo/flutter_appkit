import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:libcli/permission/permission.dart' as permission;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'printer.dart';
import 'print_queue.dart';
import 'network_device.dart';
import 'ticket.dart';
import 'ticket_to_print.dart';

class SettingPrinterDetailProvider with ChangeNotifier {
  SettingPrinterDetailProvider(
    Printer printer,
  ) {
    bluetoothDevice = printer.bluetoothDevice;
    networkDevice = printer.networkDevice;
    if (bluetoothDevice != null) {
      isBluetoothSupported = true;
      bluetooth.text = bluetoothDevice!.name ?? printer.bluetoothDevice!.address ?? 'connected';
      printerType.value = 1;
    } else if (networkDevice != null) {
      ip.text = printer.networkDevice!.host;
      printerType.value = 0;
    }

    name.text = printer.name;
    paper.value = printer.paperSize;
    printReceipt.value = printer.printReceipt;
    printCopy.value = printer.printCopy;
    printOrder.value = printer.printOrder;
  }

  @override
  void dispose() {
    name.dispose();
    bluetooth.dispose();
    paper.dispose();
    printReceipt.dispose();
    printCopy.dispose();
    printOrder.dispose();
    printerType.dispose();
    ip.dispose();
    focusBluetooth.dispose();
    focusSearch.dispose();
    focusName.dispose();
    focusIP.dispose();
    focusPaper.dispose();
    super.dispose();
  }

  BluetoothDevice? bluetoothDevice;

  NetworkDevice? networkDevice;

  final name = TextEditingController();

  final bluetooth = TextEditingController();

  final paper = ValueNotifier<PaperSize>(PaperSize.mm58);

  final printReceipt = ValueNotifier<bool>(true);

  final printCopy = ValueNotifier<bool>(true);

  final printOrder = ValueNotifier<bool>(true);

  final printerType = ValueNotifier<int>(0);

  final ip = TextEditingController();

  final focusBluetooth = FocusNode(debugLabel: 'bluetooth');

  final focusSearch = FocusNode(debugLabel: 'search');

  final focusName = FocusNode(debugLabel: 'name');

  final focusIP = FocusNode(debugLabel: 'ip');

  final focusPaper = FocusNode(debugLabel: 'paper');

  bool? isBluetoothSupported;

  Future<void> printTestPage(BuildContext context, PrintQueue printQueue) async {
    final error = await _printTestPage(context, printQueue);
    if (error.isNotEmpty) {
      dialog.alert(context, error, warning: true);
    }
  }

  Future<String> _printTestPage(BuildContext context, PrintQueue printQueue) async {
    try {
      if (printerType.value == 0 && networkDevice == null) {
        return context.i18n.printerNeedIP;
      }
      if (printerType.value == 1 && bluetoothDevice == null) {
        return context.i18n.printerNeedBT;
      }

      String error = '';
      await dialog.withLoadingThenDone(context, () async {
        final generator = await createGenerator(paper.value);
        final ticketBytes = await ticketToPrint(context, generator, testReceipt(context));
        if (printerType.value == 0) {
          error = await networkDevice!.print(context, ticketBytes);
        } else if (printerType.value == 1 && printQueue.bluetooth != null) {
          error = await printQueue.bluetooth!.print(context, PrinterBluetooth(bluetoothDevice!), ticketBytes);
        }
        return error.isEmpty;
      });
      return error;
    } finally {
      notifyListeners();
    }
  }

  /// checkBluetooth set _isBluetoothSupported to true if bluetooth is supported
  Future<void> checkBluetooth(BuildContext context, PrintQueue printQueue) async {
    if (isBluetoothSupported == null) {
      isBluetoothSupported = await permission.bluetooth(context);
      notifyListeners();
    }
  }

  void setNetworkDevice(String ip) {
    networkDevice = NetworkDevice(ip);
    bluetoothDevice = null;
  }

  void setBluetoothDevice(BluetoothDevice device) {
    bluetoothDevice = device;
    networkDevice = null;
  }

  void saveTo(Printer printer) {
    if (printerType.value == 0) {
      printer.networkDevice = networkDevice;
      printer.bluetoothDevice = null;
    } else {
      printer.bluetoothDevice = bluetoothDevice;
      printer.networkDevice = null;
    }
    printer.paperSize = paper.value;
    printer.printReceipt = printReceipt.value;
    printer.printCopy = printCopy.value;
    printer.printOrder = printOrder.value;
    printer.name = name.text;
  }
}
