// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/storage/storage.dart' as storage;
import 'print_job.dart';
import 'printer.dart';
import 'ticket.dart';
import 'bluetooth.dart';

void main() {
  setUp(() async {
    storage.initForTest({});
  });

  group('[print-job]', () {
    test('should print at good printer', () async {
      final goodPrinter = MockPrinter('GoodPrinter', true);
      final job = PrintJob(
        printer: goodPrinter,
        ticket: mockTicket(),
        createTime: DateTime.now(),
      );
      final printed = await job.print(testing.Context(), null);
      expect(printed, true);
      expect(job.isCompleted, true);
    });

    test('should not print if ticket is expire', () async {
      final goodPrinter = MockPrinter('GoodPrinter', true);
      final job = PrintJob(
        printer: goodPrinter,
        ticket: mockTicket(),
        createTime: DateTime.now().add(const Duration(hours: -3)),
      );
      final printed = await job.print(testing.Context(), null);
      expect(printed, false);
      expect(job.isCompleted, true);
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
