import 'package:flutter/material.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'package:piyuo/libcli/dialog/message_dialog.dart';

class AlertNoInternetProvider extends AsyncProvider {}

class AlertNoInternet extends ProviderWidget<AlertNoInternetProvider> {
  AlertNoInternet() : super('dialog');

  @override
  createProvider(BuildContext context) => AlertNoInternetProvider();

  @override
  Widget onBuild(BuildContext context) {
    return MessageDialog(
      color: Colors.orange[800],
      icon: Icons.cloud_off,
      title: 'netTitle'.i18n(context),
      okText: 'retry'.i18n(context),
      okPressed: () {
        print('ok pressed');
      },
      closeText: 'close'.i18n(context),
      closePressed: () {
        print('ok pressed');
      },
      message: 'netMsg'.i18n(context),
    );
  }
}
