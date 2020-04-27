import 'package:flutter/material.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialog/message_dialog.dart';

class DialogTimeoutProvider extends AsyncProvider {}

class DialogTimeoutOptions {
  final Function(bool retry) onPressed;

  final Function onEmailLinkPressed;

  final String errorCode;

  DialogTimeoutOptions(
      {this.onEmailLinkPressed, this.onPressed, this.errorCode});
}

class DialogTimeout extends ProviderWidget<DialogTimeoutProvider> {
  final DialogTimeoutOptions options;

  DialogTimeout(this.options) : super(i18nFilename: 'dialog');

  @override
  createProvider(BuildContext context) => DialogTimeoutProvider();

  @override
  Widget createWidget(BuildContext context) => DialogTimeoutWidget(options);
}

class DialogTimeoutWidget extends StatelessWidget {
  final DialogTimeoutOptions options;

  DialogTimeoutWidget(this.options);

  void close(BuildContext context, bool retry) {
    Navigator.of(context).pop();
    if (options.onPressed != null) {
      options.onPressed(retry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageDialog(
      color: Colors.red,
      icon: Icons.access_time,
      title: 'timeoutTitle'.i18n(context),
      okText: 'retry'.i18n_,
      okOnPressed: () => close(context, true),
      closeText: 'close'.i18n_,
      closeOnPressed: () => close(context, false),
      linkText: 'emailUs'.i18n_,
      linkIcon: Icons.mail_outline,
      linkOnPressed: options.onEmailLinkPressed,
      message: 'timeoutMsg'.i18n(context),
      notes: options.errorCode != null
          ? 'errCode'.i18n_ + options.errorCode
          : null,
    );
  }
}
