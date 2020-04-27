import 'package:flutter/material.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialog/message_dialog.dart';

class DialogChoice extends StatelessWidget {
  final Color color;

  final IconData icon;

  final String title;

  final String message;

  final String ok;

  final String cancel;

  DialogChoice(
      {this.title, this.message, this.color, this.icon, this.ok, this.cancel});

  @override
  Widget build(BuildContext context) {
    return MessageDialog(
      color: color ?? Colors.blue,
      icon: icon ?? Icons.info_outline,
      title: title,
      okText: ok ?? 'ok'.i18n_,
      okOnPressed: () => Navigator.of(context).pop(true),
      closeText: cancel ?? 'cancel'.i18n_,
      closeOnPressed: () => Navigator.of(context).pop(false),
      message: message,
    );
  }
}
