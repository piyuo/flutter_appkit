import 'package:flutter/material.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialog/message_dialog.dart';

class DialogError extends StatelessWidget {
  final Function onEmailLinkPressed;

  final String errorCode;

  DialogError({this.onEmailLinkPressed, this.errorCode});

  @override
  Widget build(BuildContext context) {
    return MessageDialog(
      color: Colors.red,
      icon: Icons.error_outline,
      title: 'errTitle'.i18n_,
      okText: 'close'.i18n_,
      okOnPressed: () => Navigator.of(context).pop(),
      linkText: 'emailUs'.i18n_,
      linkIcon: Icons.mail_outline,
      linkOnPressed: onEmailLinkPressed,
      message: 'errMsg'.i18n_,
      notes: errorCode != null ? 'errCode'.i18n_ + errorCode : null,
    );
  }
}
