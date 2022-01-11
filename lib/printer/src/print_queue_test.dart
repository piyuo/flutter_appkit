// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/storage/storage.dart' as storage;
import 'print_queue.dart';
import 'printer.dart';
import 'ticket.dart';
import 'bluetooth.dart';

void main() {
  setUp(() async {
    storage.initForTest({});
  });

  group('[print-queue]', () {
    test('should generate printer\'s name', () async {
      final printQueue = PrintQueue(initBluetooth: false);
      try {
        final name = printQueue.generatePrinterName('PRINTER', 5);
        expect(name, 'PRINTER-5');
      } finally {
        printQueue.dispose();
      }
    });

    test('should print at good printer', () async {
      final printQueue = PrintQueue(initBluetooth: false);
      final goodPrinter = MockPrinter('GoodPrinter', true);
      try {
        printQueue.addPrinter(goodPrinter);
        expect(printQueue.printers.length, 1);
        await printQueue.push(testing.Context(), mockTicket());
        expect(goodPrinter.lastTicket, isNotNull);
        expect(goodPrinter.printCount, 1);
        expect(goodPrinter.lastTicket!.title, 'mock');
        // printer name exists
        final result = printQueue.isPrinterNameExists('GoodPrinter');
        expect(result, true);

        // get printer by name
        final printer2 = printQueue.getPrinterByName('GoodPrinter');
        expect(printer2, goodPrinter);
        // remove printer
        printQueue.removePrinter(goodPrinter);
        await printQueue.push(testing.Context(), mockTicket());
        expect(goodPrinter.printCount, 1);
      } finally {
        printQueue.dispose();
      }
    });

    test('should retry at bad printer', () async {
      final printQueue = PrintQueue(
        initBluetooth: false,
        failedRetryTime: const Duration(
          milliseconds: 450,
        ),
      );
      dialog.disableAlert();
      final badPrinter = MockPrinter('BadPrinter', false);
      try {
        printQueue.addPrinter(badPrinter);
        await printQueue.push(testing.Context(), mockTicket());
        expect(badPrinter.printCount, 1);
        // one second can retry 2 times
        await Future.delayed(const Duration(seconds: 1));
        expect(badPrinter.printCount >= 3, true);
      } finally {
        printQueue.dispose();
      }
    });
  });
}

Ticket mockTicket() => Ticket(
      TicketType.receipt,
      title: 'mock',
    );

class MockPrinter extends Printer {
  MockPrinter(String name, this.result) {
    this.name = name;
    printReceipt = true;
    printCopy = true;
    printOrder = true;
  }

  Ticket? lastTicket;

  int printCount = 0;

  bool result;

  @override
  bool get hasDevice => true;

  @override
  Future<bool> print(BuildContext context, Ticket ticket, {Bluetooth? bluetooth}) async {
    lastTicket = ticket;
    printCount++;
    return result;
  }
}
