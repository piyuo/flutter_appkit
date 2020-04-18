import 'package:flutter/material.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'package:piyuo/libcli/dialog/message_dialog.dart';

class AlertBlockedInternetProvider extends AsyncProvider {}

class AlertBlockedInternet
    extends ProviderWidget<AlertBlockedInternetProvider> {
  AlertBlockedInternet() : super('dialog');

  @override
  createProvider(BuildContext context) => AlertBlockedInternetProvider();

  @override
  Widget onBuild(BuildContext context) {
    return MessageDialog(
      color: Color.fromRGBO(203, 29, 57, 1),
      icon: Icons.vpn_lock,
      title: 'blockTitle'.i18n(context),
      okText: 'close'.i18n(context),
      okPressed: () {
        print('ok pressed');
      },
      linkText: 'blockLink'.i18n(context),
      linkIcon: Icons.link,
      linkPressed: () {
        print('link pressed');
      },
      message: 'blockMsg'.i18n(context),
    );
  }
}
