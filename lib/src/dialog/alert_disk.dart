import 'package:flutter/material.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'package:piyuo/libcli/dialog/message_dialog.dart';

class AlertDiskProvider extends AsyncProvider {}

class AlertDisk extends ProviderWidget<AlertDiskProvider> {
  AlertDisk() : super('dialog');

  @override
  createProvider(BuildContext context) => AlertDiskProvider();

  @override
  Widget onBuild(BuildContext context) {
    return MessageDialog(
      color: Color.fromRGBO(203, 29, 57, 1),
      icon: Icons.devices,
      title: 'diskTitle'.i18n(context),
      okText: 'close'.i18n(context),
      okPressed: () {
        print('ok pressed');
      },
      message: 'diskMsg'.i18n(context),
    );
  }
}
