import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/validator/validator.dart' as validator;
import 'package:flutter/services.dart';
import 'bluetooth_scanner.dart';
import 'printer.dart';
import 'print_queue.dart';
import 'setting_printer_detail_provider.dart';

/// showPrinterDetail show printer detail setting
Future showPrinterDetail(
  BuildContext context, {
  required PrintQueue printServer,
  required Printer printer,
  required bool isNewPrinter,
}) async {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SettingPrinterDetail(
        printQueue: printServer,
        printServer: printer,
        isNewPrinter: isNewPrinter,
      ),
    ),
  );
}

class SettingPrinterDetail extends StatelessWidget {
  SettingPrinterDetail({
    required this.printQueue,
    required this.printServer,
    required this.isNewPrinter,
    Key? key,
  }) : super(key: key);

  /// printServer is print server
  final PrintQueue printQueue;

  /// printer is current bluetooth printer
  final Printer printServer;

  final _keyForm = GlobalKey<FormState>(debugLabel: 'form');

  final _keyName = const Key('name');

  final _keyIP = const Key('ip');

  final _keyBluetooth = const Key('bluetooth');

  final _keyPaper = const Key('paper');

  final _keySubmit = const Key('submit');

  final _keyDelete = const Key('delete');

  /// isNewPrinter set to true when printer is newly create
  final bool isNewPrinter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.i18n.printerSettings),
      ),
      body: SafeArea(
        right: false,
        bottom: true,
        child: SingleChildScrollView(
            child: ChangeNotifierProvider<SettingPrinterDetailProvider>(
                create: (context) => SettingPrinterDetailProvider(printServer),
                child: Consumer<SettingPrinterDetailProvider>(
                    builder: (context, provide, _) => Form(
                          key: _keyForm,
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  // PrinterServer error
                                  if (printServer.error.isNotEmpty)
                                    Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: delta.ErrorBox(
                                          message: printServer.error,
                                        )),
                                  // Printer Type
                                  SizedBox(
                                    height: 134,
                                    child: delta.SegmentContainer(
                                      segmentControl: delta.SlideSegment<int>(
                                        onBeforeChange: (int? index) async {
                                          if (index == 1) {
                                            provide.checkBluetooth(context, printQueue);
                                          }
                                        },
                                        controller: provide.printerType,
                                        children: {
                                          0: Text(context.i18n.networkPrinter),
                                          1: Text(context.i18n.bluetoothPrinter),
                                        },
                                      ),
                                      padding: const EdgeInsets.only(top: 10),
                                      controller: provide.printerType,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            // IP
                                            form.InputField(
                                                key: _keyIP,
                                                focusNode: provide.focusIP,
                                                controller: provide.ip,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [
                                                  validator.decimalNumberFormatter,
                                                ],
                                                label: context.i18n.printerIP,
                                                hint: context.i18n.printerIPHint,
                                                validator: (value) {
                                                  if (provide.printerType.value != 0) {
                                                    return null;
                                                  }
                                                  final result = validator.ipAddressRegexp.hasMatch(value!.text)
                                                      ? null
                                                      : context.i18n.printerIPNotValid.replace1(value.text);
                                                  if (result == null) {
                                                    provide.setNetworkDevice(value.text);
                                                  }
                                                  return result;
                                                }),
                                            delta.Hypertext(fontSize: 13)
                                              ..moreDoc(context.i18n.printerFindIP, docName: 'privacy'),
                                          ],
                                        ),
                                        // Bluetooth Search
                                        provide.isBluetoothSupported == false
                                            ? Text(context.i18n.bluetoothPrinterNotSupport,
                                                style: TextStyle(color: Colors.red.shade400))
                                            : form.InputField(
                                                key: _keyBluetooth,
                                                decoration: InputDecoration(
                                                  labelText: context.i18n.bluetoothPrinter,
                                                  hintText: context.i18n.bluetoothPrinterHint,
                                                  suffixIcon: ElevatedButton.icon(
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty.all(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(25),
                                                          ),
                                                        ),
                                                      ),
                                                      focusNode: provide.focusSearch,
                                                      icon: const Icon(Icons.bluetooth),
                                                      label: Text(context.i18n.searchButtonText),
                                                      onPressed: () async {
                                                        final result =
                                                            await selectBluetoothPrinter(context, printQueue.bluetooth);
                                                        if (result != null) {
                                                          provide.setBluetoothDevice(BluetoothDevice()
                                                            ..name = result.name
                                                            ..address = result.address
                                                            ..type = result.type);
                                                        }
                                                      }),
                                                ),
                                                readOnly: true,
                                                controller: provide.bluetooth,
                                                requiredField: provide.printerType.value == 0,
                                                focusNode: provide.focusBluetooth,
                                              ),
                                      ],
                                    ),
                                  ),
                                  // Paper Size
                                  form.RadioGroup<PaperSize>(
                                    key: _keyPaper,
                                    controller: provide.paper,
                                    items: {
                                      PaperSize.mm58: context.i18n.ticket58mm,
                                      PaperSize.mm80: context.i18n.ticket80mm,
                                    },
                                    label: context.i18n.ticketPaperSize,
                                    focusNode: provide.focusPaper,
                                  ),
                                  form.br(),
                                  // print test page
                                  OutlinedButton.icon(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(vertical: 12, horizontal: 36)),
                                        side: MaterialStateProperty.all(BorderSide(
                                          color: provide.bluetoothDevice != null ? Colors.blue.shade600 : Colors.grey,
                                          style: BorderStyle.solid,
                                          width: 1,
                                        )),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                        ),
                                      ),
                                      icon: Icon(Icons.print,
                                          color: context.themeColor(
                                              light: Colors.grey.shade700, dark: Colors.grey.shade200)),
                                      label: Text(context.i18n.printTestPage,
                                          style: TextStyle(
                                              color: context.themeColor(
                                                  light: Colors.grey.shade700, dark: Colors.grey.shade200))),
                                      onPressed: () async => await provide.printTestPage(context, printQueue)),
                                  form.br(),
                                  form.InputField(
                                    key: _keyName,
                                    focusNode: provide.focusName,
                                    controller: provide.name,
                                    label: context.i18n.printerName,
                                    hint: context.i18n.printerNameHint,
                                    requiredField: true,
                                    validator: (TextEditingValue? value) {
                                      if (value != null &&
                                          printQueue.isPrinterNameExists(value.text, except: printServer)) {
                                        return context.i18n.printerNameExists.replace1(value.text);
                                      }
                                      return null;
                                    },
                                  ),
                                  form.br(),
                                  Text(context.i18n.printAutoLabel,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(context.i18n.ticketTypeReceipt),
                                      ),
                                      delta.Switching(
                                        controller: provide.printReceipt,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(context.i18n.ticketTypeCopy),
                                      ),
                                      delta.Switching(
                                        controller: provide.printCopy,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(context.i18n.ticketTypeOrder),
                                      ),
                                      delta.Switching(
                                        controller: provide.printOrder,
                                      ),
                                    ],
                                  ),
                                  form.br(),
                                  form.Button(
                                    key: _keySubmit,
                                    form: _keyForm,
                                    label: context.i18n.saveButtonText,
                                    onClick: () async {
                                      if (provide.printerType.value == 1 && provide.isBluetoothSupported == false) {
                                        return;
                                      }
                                      if (isNewPrinter) {
                                        printQueue.printers.add(printServer);
                                      }
                                      provide.saveTo(printServer);
                                      await printQueue.save(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  if (!isNewPrinter) form.br(),
                                  if (!isNewPrinter) delta.Separator(height: 2, color: Colors.red.shade200),
                                  if (!isNewPrinter) form.br(),
                                  if (!isNewPrinter)
                                    form.Button(
                                      elevation: 0,
                                      color: Colors.red[400],
                                      key: _keyDelete,
                                      label: context.i18n.deleteButtonText,
                                      onClick: () async {
                                        printServer.disable();
                                        printQueue.printers.remove(printServer);
                                        await printQueue.save(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                ],
                              )),
                        )))),
      ),
    );
  }
}
