import 'package:flutter/material.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialog/message_dialog.dart';

class DialogAlert extends StatelessWidget {
  final Color color;

  final IconData icon;

  final String title;

  final String message;

  DialogAlert({
    this.title,
    this.message,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return MessageDialog(
      color: color ?? Colors.red,
      icon: icon ?? Icons.info_outline,
      title: title,
      okText: 'close'.i18n_,
      okOnPressed: () => Navigator.of(context).pop(),
      message: message,
    );
  }
}
