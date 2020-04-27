import 'package:flutter/material.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialog/message_dialog.dart';

class DialogDiskErrorProvider extends AsyncProvider {}

class DialogDiskErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MessageDialog(
      color: Colors.red,
      icon: Icons.devices,
      title: 'diskTitle'.i18n(context),
      okText: 'close'.i18n_,
      okOnPressed: () => Navigator.of(context).pop(),
      message: 'diskMsg'.i18n(context),
    );
  }
}

class DialogDiskError extends ProviderWidget<DialogDiskErrorProvider> {
  DialogDiskError() : super(i18nFilename: 'dialog');

  @override
  createProvider(BuildContext context) => DialogDiskErrorProvider();

  @override
  Widget createWidget(BuildContext context) => DialogDiskErrorWidget();
}
