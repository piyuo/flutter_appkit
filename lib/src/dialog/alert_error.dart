import 'package:flutter/material.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'package:piyuo/libcli/dialog/message_dialog.dart';

class AlertErrorProvider extends AsyncProvider {}

class AlertError extends ProviderWidget<AlertErrorProvider> {
  AlertError() : super('dialog');

  @override
  createProvider(BuildContext context) => AlertErrorProvider();

  @override
  Widget onBuild(BuildContext context) {
    return MessageDialog(
      color: Color.fromRGBO(203, 29, 57, 1),
      icon: Icons.error_outline,
      title: 'errTitle'.i18n(context),
      okText: 'close'.i18n(context),
      okPressed: () {
        print('ok pressed');
      },
      linkText: 'emailUs'.i18n(context),
      linkIcon: Icons.mail_outline,
      linkPressed: () {
        print('link pressed');
      },
      message: 'errMsg'.i18n(context),
    );
  }
}
