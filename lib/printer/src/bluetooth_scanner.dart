import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'bluetooth.dart';

//todo:detect os not give permission
/// selectBluetoothPrinter bluetooth printer and let use choose 1 printer
Future<PrinterBluetooth?> selectBluetoothPrinter(BuildContext context, Bluetooth? bluetooth) async {
  if (bluetooth == null) {
    return null;
  }

  _BluetoothScannerProvider provider = _BluetoothScannerProvider(manager: bluetooth);
  try {
    await provider._startScan();
    final printer = await dialog.routeOrDialog(
      context,
      BluetoothScanner(bluetooth, provider),
    );
    return printer;
  } finally {
    await provider._stopScan();
  }
}

class _BluetoothScannerProvider with ChangeNotifier {
  _BluetoothScannerProvider({
    required this.manager,
  });

  Future<void> _startScan() async {
    _subscription = await manager.listenDevices((List<PrinterBluetooth> devices) async {
      debugPrint('[printer] devices found ${devices.length}');
      _devices = devices;
      notifyListeners();
    });
    await manager.startScanDevices();
    debugPrint('[printer.bluetooth] scan start');
  }

  Future<void> _stopScan() async {
    await _subscription.cancel();
    await manager.stopScanDevices();
    debugPrint('[printer.bluetooth] scan stop');
  }

  /// manager is receipt printer manager
  final Bluetooth manager;

  /// _devices is scanned devices
  List<PrinterBluetooth> _devices = [];

  /// _subscription listen find devices result
  late StreamSubscription<List<PrinterBluetooth>> _subscription;

  List<delta.ListItem> _devicesList(BuildContext context) {
    final list = <delta.ListItem>[];
    for (PrinterBluetooth device in _devices) {
      final deviceName = device.name ?? context.i18n.noName;
      final item = delta.ListItem(
        device,
        title: deviceName,
      );
      if (deviceName.toLowerCase().contains('print') || deviceName.contains('印')) {
        list.insert(0, item);
      } else {
        list.add(item);
      }
    }
    return list;
  }
}

class BluetoothScanner extends StatelessWidget {
  const BluetoothScanner(
    this.manager,
    this.provider, {
    Key? key,
  }) : super(key: key);

  final Bluetooth manager;

  final _BluetoothScannerProvider provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.i18n.bluetoothScanTitle),
      ),
      body: SafeArea(
          right: false,
          bottom: true,
          child: ChangeNotifierProvider.value(
              value: provider,
              child: Consumer<_BluetoothScannerProvider>(
                  builder: (context, provide, _) => Column(children: [
                        Expanded(
                          child: delta.Listing<PrinterBluetooth>(
                            controller: ValueNotifier(null),
                            selectedTileColor: Colors.blue,
                            selectedFontColor: Colors.white,
                            dividerColor: context.themeColor(light: Colors.grey[300]!, dark: Colors.grey[800]!),
                            items: provide._devicesList(context),
                            onItemTap: (BuildContext context, PrinterBluetooth value) {
                              Navigator.pop(context, value);
                            },
                          ),
                        ),
                        Container(
                          color: context.themeColor(light: Colors.grey[300]!, dark: Colors.grey[900]!),
                          height: 120,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 35,
                                left: 0,
                                right: 0,
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: delta.ballScaleIndicator(colors: [
                                    Colors.blue[200]!,
                                    Colors.blue,
                                    Colors.blue[800]!,
                                  ]),
                                ),
                              ),
                              const Positioned(
                                left: 0,
                                right: 0,
                                bottom: 60,
                                child: Icon(
                                  Icons.bluetooth,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 30,
                                child: Text(context.i18n.printerScanning,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: context.themeColor(
                                        light: Colors.grey[800]!,
                                        dark: Colors.grey[300]!,
                                      ),
                                    )),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 10,
                                child: Text(context.i18n.printerTurnOnPower,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: context.themeColor(
                                        light: Colors.grey[800]!,
                                        dark: Colors.grey[300]!,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ])))),
    );
  }
}
