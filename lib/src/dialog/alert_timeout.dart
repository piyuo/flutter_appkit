import 'package:flutter/material.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'package:piyuo/libcli/dialog/message_dialog.dart';

class AlertTimeoutProvider extends AsyncProvider {}

class AlertTimeout extends ProviderWidget<AlertTimeoutProvider> {
  AlertTimeout() : super('dialog');

  @override
  createProvider(BuildContext context) => AlertTimeoutProvider();

  @override
  Widget onBuild(BuildContext context) {
    return MessageDialog(
      color: Color.fromRGBO(203, 29, 57, 1),
      icon: Icons.access_time,
      title: 'timeoutTitle'.i18n(context),
      okText: 'retry'.i18n(context),
      okPressed: () {
        print('ok pressed');
      },
      closeText: 'close'.i18n(context),
      closePressed: () {
        print('ok pressed');
      },
      linkText: 'emailUs'.i18n(context),
      linkIcon: Icons.mail_outline,
      linkPressed: () {
        print('link pressed');
      },
      message: 'timeoutMsg'.i18n(context),
    );
  }
}
