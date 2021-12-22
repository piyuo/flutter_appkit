// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:provider/provider.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import '../printer.dart';

main() => app.start(
      providers: [
        ChangeNotifierProvider<PrintQueue>(
          create: (context) => PrintQueue(),
        )
      ],
      appName: 'printer',
      locationBuilder: app.simpleLocationBuilder((_, __, ___) => const Example()),
    );

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PrintQueue>(
        builder: (context, queue, child) => Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      SizedBox(
                        width: 600,
                        height: 600,
                        child: _broadcastTicket(context),
                      ),
                      testing.example(
                        context,
                        text: 'preview receipt',
                        child: _previewReceipt(context, queue.bluetooth!),
                      ),
                      testing.example(
                        context,
                        text: 'preview test receipt',
                        child: _previewTestReceipt(context, queue.bluetooth!),
                      ),
                      testing.example(
                        context,
                        text: 'print server',
                        child: _printServer(context, queue),
                      ),
                      testing.example(
                        context,
                        text: 'printer setting',
                        child: _printerSetting(context),
                      ),
                      testing.example(
                        context,
                        text: 'broadcast ticket',
                        child: _broadcastTicket(context),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}

Widget _previewReceipt(BuildContext context, Bluetooth manager) {
  return TicketPreview(
    receipt: _demoReceipt(),
  );
}

Widget _previewTestReceipt(BuildContext context, Bluetooth manager) {
  return TicketPreview(
    receipt: testReceipt(context),
  );
}

Widget _printServer(BuildContext context, PrintQueue queue) {
  return Column(
    children: [
      OutlinedButton(
          child: const Text('scan'),
          onPressed: () async {
            final printer = await selectBluetoothPrinter(context, queue.bluetooth);
            if (printer != null) {
              debugPrint('got printer ${printer.address}');
              final profile = await CapabilityProfile.load();
              final generator = Generator(PaperSize.mm58, profile);
              final ticket = await ticketToPrint(context, generator, _demoReceipt());
              await queue.bluetooth!.print(context, printer, ticket);
            } else {
              debugPrint('not support platform or no paired printer');
            }
          }),
    ],
  );
}

Widget _printerSetting(BuildContext context) {
  return const SizedBox(
    width: 600,
    height: 600,
    child: SettingPrinterList(),
  );
}

Widget _broadcastTicket(BuildContext context) {
  return OutlinedButton(
    child: const Text('broadcast ticket'),
    onPressed: () {
      eventbus.broadcast(
          context,
          PrintTicketEvent(
            ticket: _demoReceipt(),
          ));
    },
  );
}

Ticket _demoReceipt() => Ticket(
      TicketType.receipt,
      decimalDigits: 0,
      title: 'piyuo',
      address: 'https://piyuo.com',
      orderNumber: '1234-567-8901',
      orderDate: DateTime.now(),
      orderType: OrderType.delivery,
      customerName: 'CHIEN CHIH',
      pickupTime: DateTime.now(),
      notes: '不用免洗餐具',
      itemCount: 99,
      items: [
        TicketItem(name: 'Product AAA', qty: 1, salesAmount: 100, detail: [
          TicketItem(name: 'extra large', salesAmount: 50),
          TicketItem(name: 'egg', qty: 1, salesAmount: 10),
        ]),
        TicketItem(name: 'Product BBB', qty: 1, salesAmount: 30),
        TicketItem(name: 'product CCC', qty: 1, salesAmount: 20),
        TicketItem(name: '中文測試', qty: 1, salesAmount: 30),
      ],
      subtotal: 180,
      tax: 7.99,
      taxPercentage: 0.075,
      service: 15,
      servicePercentage: 0.15,
      tip: 20,
      tipPercentage: 0.18,
      delivery: 30,
      total: 2200,
      extraName: '統一編號',
      extraValue: '12345678',
      qrMessage: 'scan qr code to see order online',
      qrcode: 'hello world',
      message: 'Thank your!',
    );
