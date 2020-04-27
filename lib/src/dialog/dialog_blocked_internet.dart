import 'package:flutter/material.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialog/message_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogBlockedInternetProvider extends AsyncProvider {}

class DialogBlockedInternetWidget extends StatelessWidget {
  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageDialog(
      color: Colors.red,
      icon: Icons.vpn_lock,
      title: 'blockTitle'.i18n(context),
      okText: 'close'.i18n_,
      okOnPressed: () => Navigator.of(context).pop(),
      linkText: 'blockLink'.i18n(context),
      linkIcon: Icons.link,
      linkOnPressed: () => launchUrl('http://www.cloudfunctions.net'),
      message: 'blockMsg'.i18n(context),
    );
  }
}

class DialogBlockedInternet
    extends ProviderWidget<DialogBlockedInternetProvider> {
  DialogBlockedInternet() : super(i18nFilename: 'dialog', package: 'libcli');

  @override
  createProvider(BuildContext context) => DialogBlockedInternetProvider();

  @override
  Widget createWidget(BuildContext context) => DialogBlockedInternetWidget();
}
