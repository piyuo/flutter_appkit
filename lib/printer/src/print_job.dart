import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'ticket.dart';
import 'printer.dart';
import 'bluetooth.dart';
import 'dart:async';

/// FailedToPrintEvent is failed to print event
///
class FailedToPrintEvent extends eventbus.Event {
  FailedToPrintEvent(this.printerNama);

  final String printerNama;
}

/// printJobInvalid is the time queued print job will be invalid
const printJobInvalid = Duration(hours: 2);

class PrintJob {
  PrintJob({
    required this.printer,
    required this.ticket,
    required this.createTime,
  });

  final Printer printer;

  final Ticket ticket;

  final DateTime createTime;

  bool isCompleted = false;

  /// print return true if print job is success print
  Future<bool> print(BuildContext context, Bluetooth? bluetooth) async {
    if (printer.error.isNotEmpty) {
      debugPrint('${printer.name} stop because ${printer.error}');
      return false;
    }
    if (createTime.add(printJobInvalid).isBefore(DateTime.now())) {
      isCompleted = true;
      return false;
    }

    final ok = await printer.print(context, ticket, bluetooth: bluetooth);
    if (!ok) {
      dialog.alert(
        context,
        printer.error,
        title: context.i18n.errorPrint.replace1(printer.name),
        icon: Icons.print,
        warning: true,
      );
      eventbus.broadcast(context, FailedToPrintEvent(printer.name));
      return false;
    }
    isCompleted = true;
    return true;
  }
}
