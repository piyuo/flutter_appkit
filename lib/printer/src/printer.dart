import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'ticket.dart';
import 'ticket_to_print.dart';
import 'bluetooth.dart';
import 'network_device.dart';

/// _keyName is the key for the name
const _keyName = 'name';

/// _keyPaperSize is the key for the name
const _keyPaperSize = 'size';

/// _keyBluetooth is the key for the bluetooth device
const _keyBluetooth = 'bt';

/// _keyNetwork is the key for the network device
const _keyNetwork = 'nt';

/// _keyPrintReceipt is the key for the print receipt
const _keyPrintReceipt = 'pr';

/// _keyPrintCopy is the key for the print receipt copy
const _keyPrintCopy = 'pc';

/// _keyPrintOrder is the key for the print order
const _keyPrintOrder = 'po';

/// PrinterType is printer type
enum PrinterType { none, wifi, bluetooth }

class Printer {
  String error = '';

  String name = '';

  PaperSize paperSize = PaperSize.mm58;

  bool printReceipt = true;

  bool printCopy = false;

  bool printOrder = false;

  /// bluetoothDevice must have value if use bluetooth printing
  BluetoothDevice? bluetoothDevice;

  /// networkDevice must have value if use network printing
  NetworkDevice? networkDevice;

  PrinterType get type {
    if (bluetoothDevice != null) {
      return PrinterType.bluetooth;
    }
    return PrinterType.none;
  }

  /// toJSON save printer to json
  Map<String, dynamic> toJSON() {
    final json = <String, dynamic>{};
    json[_keyName] = name;
    json[_keyPaperSize] = paperSize.value;
    json[_keyPrintReceipt] = printReceipt;
    json[_keyPrintCopy] = printCopy;
    json[_keyPrintOrder] = printOrder;
    if (bluetoothDevice != null) {
      final jsonDevice = bluetoothDevice!.toJson();
      json[_keyBluetooth] = jsonDevice;
    }
    if (networkDevice != null) {
      json[_keyNetwork] = networkDevice!.host;
    }
    return json;
  }

  /// fromJSON create bluetooth printer from json
  static Printer fromJSON(Map<String, dynamic> json) {
    final paperSizeValue = json[_keyPaperSize];
    PaperSize paperSize = PaperSize.mm80;
    if (paperSizeValue == PaperSize.mm58.value) {
      paperSize = PaperSize.mm58;
    }

    BluetoothDevice? bluetoothDevice;
    final bJson = json[_keyBluetooth];
    if (bJson != null) {
      bluetoothDevice = BluetoothDevice.fromJson(bJson);
    }

    NetworkDevice? networkDevice;
    final nJson = json[_keyNetwork];
    if (nJson != null) {
      networkDevice = NetworkDevice(nJson);
    }

    return Printer()
      ..name = json[_keyName]
      ..bluetoothDevice = bluetoothDevice
      ..networkDevice = networkDevice
      ..paperSize = paperSize
      ..printReceipt = json[_keyPrintReceipt]
      ..printCopy = json[_keyPrintCopy]
      ..printOrder = json[_keyPrintOrder];
  }

  /// hasDevice return true if bluetooth or network device is set
  bool get hasDevice => bluetoothDevice != null || networkDevice != null;

  /// print receipt use default printer, return false if failed to print
  Future<bool> print(
    BuildContext context,
    Ticket ticket, {
    Bluetooth? bluetooth,
  }) async {
    // check if still accept, sometime user disable printer when ticket still in queue
    if (!accept(ticket)) {
      return true;
    }

    // generate ticket bytes
    final generator = await createGenerator(paperSize);
    final ticketBytes = await ticketToPrint(context, generator, ticket);
    late String error;
    if (networkDevice != null) {
      error = await networkDevice!.print(context, ticketBytes);
    } else if (bluetoothDevice != null && bluetooth != null) {
      error = await bluetooth.print(context, PrinterBluetooth(bluetoothDevice!), ticketBytes);
    }

    if (error.isNotEmpty) {
      this.error = error;
      return false;
    }
    return true;
  }

  /// accept return true if printer can print this ticket
  bool accept(Ticket ticket) {
    if (printReceipt && ticket.type == TicketType.receipt) {
      return true;
    }
    if (printCopy && ticket.type == TicketType.receiptCopy) {
      return true;
    }
    if (printOrder && ticket.type == TicketType.order) {
      return true;
    }
    return false;
  }

  String serviceDescription(BuildContext context) {
    String result = '';
    if (printReceipt) {
      result += context.i18n.ticketTypeReceipt + ", ";
    }
    if (printCopy) {
      result += context.i18n.ticketTypeCopy + ", ";
    }
    if (printOrder) {
      result += context.i18n.ticketTypeOrder;
    }
    if (result.isNotEmpty) {
      if (result[result.length - 1] == ' ') {
        result = result.substring(0, result.length - 2);
      }
    } else {
      result = context.i18n.printerAutoDisabled;
    }
    return result;
  }

  /// enabled return true if automatically any type of ticket
  bool get enabled => printReceipt || printCopy || printOrder;

  /// disable printer before delete, this will make queued ticket not print
  void disable() {
    printReceipt = false;
    printCopy = false;
    printOrder = false;
  }
}
