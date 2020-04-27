import 'package:flutter/material.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialog/message_dialog.dart';

class DialogNoInternetProvider extends AsyncProvider {}

class DialogNoInternetOptions {
  final Function(bool retry) onPressed;

  final String errorCode;

  DialogNoInternetOptions({this.onPressed, this.errorCode});
}

class DialogNoInternetWidget extends StatelessWidget {
  final DialogNoInternetOptions options;

  DialogNoInternetWidget(this.options);

  void close(BuildContext context, bool retry) {
    Navigator.of(context).pop();
    if (options.onPressed != null) {
      options.onPressed(retry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageDialog(
      color: Colors.deepOrange[700],
      icon: Icons.cloud_off,
      title: 'netTitle'.i18n(context),
      okText: 'retry'.i18n_,
      okOnPressed: () => close(context, true),
      closeText: 'close'.i18n_,
      closeOnPressed: () => close(context, false),
      message: 'netMsg'.i18n(context),
      notes: options.errorCode != null
          ? 'errCode'.i18n_ + options.errorCode
          : null,
    );
  }
}

class DialogNoInternet extends ProviderWidget<DialogNoInternetProvider> {
  final DialogNoInternetOptions options;

  DialogNoInternet(this.options)
      : super(i18nFilename: 'dialog', package: 'libcli');

  @override
  createProvider(BuildContext context) => DialogNoInternetProvider();

  @override
  Widget createWidget(BuildContext context) => DialogNoInternetWidget(options);
}
