import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'print_queue.dart';
import 'printer.dart';
import 'setting_printer_detail.dart';

class SettingPrinterList extends StatelessWidget {
  const SettingPrinterList({
    Key? key,
  }) : super(key: key);

  List<delta.ListItem<String>> listPrinters(PrintQueue printQueue) {
    return printQueue.printers
        .map((Printer printer) => delta.ListItem<String>(
              printer.name,
              title: printer.name,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrintQueue>(
        builder: (context, printQueue, child) => dialog.CheckListDialog<String>(
              title: context.i18n.printerList,
              items: ValueNotifier<List<delta.ListItem<String>>>(listPrinters(printQueue)),
              selection: ValueNotifier<List<String>>([]),
              itemBuilder: (BuildContext context, String key, delta.ListItem item, bool selected) {
                final printer = printQueue.getPrinterByName(key);
                if (printer == null) {
                  return null;
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Icon(
                        printer.bluetoothDevice != null ? Icons.bluetooth : Icons.print,
                        color: Colors.grey,
                        size: 60,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 6),
                            child: Text(item.title ?? key.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  color: context.invertColor,
                                )),
                          ),
                          printer.error.isEmpty
                              ? delta.StatusLight(
                                  status: printer.enabled ? delta.LightStatus.green : delta.LightStatus.yellow,
                                  label: printer.serviceDescription(context),
                                )
                              : delta.ErrorLabel(message: printer.error),
                        ],
                      ),
                    ),
                  ],
                );
              },
              hint: delta.TapOnButtonHint(context.i18n.printer),
              onRefresh: () async => [...listPrinters(printQueue)],
              onNewItem: () async {
                final printer = Printer()..name = printQueue.generatePrinterName(context.i18n.printer, 1);
                await showPrinterDetail(
                  context,
                  printServer: printQueue,
                  printer: printer,
                  isNewPrinter: true,
                );
              },
              onDelete: (List<String> keys) async {
                for (int i = printQueue.printers.length - 1; i >= 0; i--) {
                  if (keys.contains(printQueue.printers[i].name)) {
                    final printer = printQueue.printers[i];
                    printer.disable();
                    printQueue.printers.removeAt(i);
                  }
                }
                await printQueue.save(context);
              },
              onItemTap: (String key) async {
                Printer? printer = printQueue.getPrinterByName(key);
                if (printer != null) {
                  await showPrinterDetail(
                    context,
                    printServer: printQueue,
                    printer: printer,
                    isNewPrinter: false,
                  );
                }
              },
            ));
  }
}
