import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/storage/storage.dart' as storage;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:synchronized/synchronized.dart';
import 'ticket.dart';
import 'printer.dart';
import 'bluetooth.dart';
import 'print_job.dart';

/// _prefKeyPrinters save all printers
const _prefKeyPrinters = 'printers';

class PrintQueue with ChangeNotifier {
  PrintQueue({
    bool initBluetooth = true,
    this.failedRetryTime = const Duration(seconds: 30),
  }) {
    if (initBluetooth) {
      bluetooth = Bluetooth();
    }
    _subEventBus = eventbus.listen((BuildContext context, dynamic e) async {
      if (e is PrintTicketEvent) {
        push(context, e.ticket);
      }
    });
    _init();
  }

  @override
  void dispose() {
    _subEventBus!.cancel();
    super.dispose();
  }

  Bluetooth? bluetooth;

  /// failedRetryTime is the retry time when error occur
  final Duration failedRetryTime;

  /// _isPrinting return true if printing now
  bool _isPrinting = false;

  /// _queueLock avoid concurrent use queue
  final _queueLock = Lock();

  /// _queue keep all waiting print jobs
  final _queue = <PrintJob>[];

  final printers = <Printer>[];

  late final eventbus.Subscription? _subEventBus;

  /// _init load printers from preferences
  Future<void> _init() async {
    if (await storage.containsKey(_prefKeyPrinters)) {
      final saved = await storage.getMapList(_prefKeyPrinters);
      if (saved != null) {
        final list = saved.map((e) => Printer.fromJSON(e)).toList();
        printers.clear();
        printers.addAll(list);
        notifyListeners();
      }
    }
  }

  /// save save printers to preferences
  Future<void> save(BuildContext context) async {
    final list = printers.map((printer) => printer.toJSON()).toList();
    await storage.setMapList(_prefKeyPrinters, list);
  }

  /// addPrinter add printer
  void addPrinter(Printer pinter) {
    printers.add(pinter);
  }

  /// removePrinter remove printer
  void removePrinter(Printer pinter) {
    printers.remove(pinter);
  }

  /// getPrinterByName return printer by name
  Printer? getPrinterByName(String printerName) {
    for (final printer in printers) {
      if (printer.name == printerName) {
        return printer;
      }
    }
    return null;
  }

  /// generatePrinterName generate printer name by add sequence number
  String generatePrinterName(String lead, int index) {
    final name = lead + '-$index';
    if (isPrinterNameExists(name)) {
      return generatePrinterName(lead, index + 1);
    }
    return name;
  }

  /// isPrinterNameExists return true if printer name already exists
  bool isPrinterNameExists(String name, {Printer? except}) {
    for (final printer in printers) {
      if (printer != except && printer.name == name) {
        return true;
      }
    }
    return false;
  }

  /// push receipt to queue
  Future<void> push(BuildContext context, Ticket ticket) async {
    debugPrint('add to print queue ${ticket.orderNumber}');
    await _queueLock.synchronized(() async {
      for (Printer printer in printers) {
        if (printer.accept(ticket)) {
          _queue.add(PrintJob(
            createTime: DateTime.now(),
            ticket: ticket,
            printer: printer,
          ));
        }
      }
    });
    if (_queue.isNotEmpty) {
      _print(context);
    }
  }

  /// _goPrint print entire queue, stop if error
  Future<void> _print(BuildContext context) async {
    if (_isPrinting) {
      return;
    }

    _isPrinting = true;
    try {
      // print all
      for (int i = 0; i < _queue.length; i++) {
        final job = _queue[i];
        await job.print(context, bluetooth);
      }
      // remove completed job
      await _queueLock.synchronized(() async {
        for (int i = _queue.length - 1; i >= 0; i--) {
          final job = _queue[i];
          if (job.isCompleted) {
            _queue.removeAt(i);
          }
        }
      });

      if (_queue.isNotEmpty) {
        Future.delayed(failedRetryTime, () => _print(context));
      }
    } finally {
      _isPrinting = false;
    }
  }
}

/// PrintTicketEvent send receipt to print
///
class PrintTicketEvent extends eventbus.Event {
  PrintTicketEvent({
    required this.ticket,
  });

  final Ticket ticket;
}
